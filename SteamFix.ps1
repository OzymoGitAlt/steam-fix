param(
    [ValidateSet("Install","Uninstall","Status","Refresh","")]
    [string]$Action = $(if ($env:STEAMFIX_ACTION) { $env:STEAMFIX_ACTION } else { "" })
)

$ErrorActionPreference = "Stop"

# Hosted script location for elevation and self-updating execution.
$SelfUrl = "https://raw.githubusercontent.com/ZeroMemInc/steam-fix/main/SteamFix.ps1"

$ServiceName = "steamfix"
$Root        = Join-Path $env:ProgramData "SteamFix"
$App         = Join-Path $env:ProgramFiles "SteamFix"
$BinDir      = Join-Path $App "x86_64"
$Exe         = Join-Path $BinDir "goodbyedpi.exe"

$TestRoot    = Join-Path $env:ProgramData "SteamFixTest"
$TestApp     = Join-Path $env:ProgramFiles "SteamFixTest"
$LegacyRoot  = Join-Path $env:ProgramData "SteamEvoFix"
$LegacyApp   = Join-Path $env:ProgramFiles "SteamEvoFix"

$ZipUrl      = "https://github.com/ValdikSS/GoodbyeDPI/releases/download/0.2.2/goodbyedpi-0.2.2.zip"
$ZipSha256   = "00a2f8b99cd817f8c7fc4c449033015f039d18af213de78cb66bf202277c0628"
$ZipSize     = 635551


function Test-Admin {
    $id = [Security.Principal.WindowsIdentity]::GetCurrent()
    $p = New-Object Security.Principal.WindowsPrincipal($id)
    return $p.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Ensure-Admin {
    param(
        [string]$RequestedAction = $Action
    )

    if (Test-Admin) { return }

    if ($PSCommandPath) {
        $args = "-NoExit -NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" -Action $RequestedAction"
        Start-Process powershell.exe -Verb RunAs -ArgumentList $args
        exit
    }

    $url = if ($env:STEAMFIX_URL) { $env:STEAMFIX_URL } else { $SelfUrl }

    if ($url -and $url -notmatch "YOUR-DOMAIN") {
        $safeUrl = $url.Replace("'", "''")
        $safeAction = $RequestedAction.Replace("'", "''")
        $cmd = "`$env:STEAMFIX_URL='$safeUrl'; `$env:STEAMFIX_ACTION='$safeAction'; irm '$safeUrl' | iex"
        $arg = "-NoExit -NoProfile -ExecutionPolicy Bypass -Command `"$cmd`""
        Start-Process powershell.exe -Verb RunAs -ArgumentList $arg
        exit
    }

    throw "Administrator rights are required. Set SelfUrl in the hosted script, or set STEAMFIX_URL before running it."
}

function Stop-OwnedService {
    param([string]$Name)
    $s = Get-Service -Name $Name -ErrorAction SilentlyContinue
    if ($s) {
        if ($s.Status -ne "Stopped") {
            Stop-Service -Name $Name -Force -ErrorAction SilentlyContinue
            Start-Sleep -Milliseconds 500
        }
        & sc.exe delete $Name | Out-Null
        Start-Sleep -Seconds 1
    }
}

function Stop-TestProcess {
    $pidFile = Join-Path $TestRoot "pid.txt"
    if (-not (Test-Path $pidFile)) { return }

    $text = (Get-Content -Raw $pidFile -ErrorAction SilentlyContinue).Trim()
    if ($text -notmatch '^\d+$') { return }

    $proc = Get-Process -Id ([int]$text) -ErrorAction SilentlyContinue
    if (-not $proc) { return }

    $expected = [IO.Path]::GetFullPath((Join-Path $TestApp "x86_64\goodbyedpi.exe"))
    try { $actual = [IO.Path]::GetFullPath($proc.Path) } catch { $actual = "" }

    if ($actual -and $actual -ieq $expected) {
        Stop-Process -Id $proc.Id -Force -ErrorAction SilentlyContinue
        Start-Sleep -Milliseconds 500
    }
}


function Stop-SteamFixRuntime {
    # Stop/delete our services BEFORE touching GoodbyeDPI/WinDivert files.
    Stop-OwnedService $ServiceName
    Stop-OwnedService "SteamEvoFix"

    # Stop only GoodbyeDPI processes that belong to SteamFix paths.
    $ownedPaths = @(
        [IO.Path]::GetFullPath($Exe),
        [IO.Path]::GetFullPath((Join-Path $LegacyApp "x86_64\goodbyedpi.exe"))
    )

    Get-Process -Name "goodbyedpi" -ErrorAction SilentlyContinue | ForEach-Object {
        try {
            $actual = [IO.Path]::GetFullPath($_.Path)
            if ($ownedPaths -contains $actual) {
                Stop-Process -Id $_.Id -Force -ErrorAction SilentlyContinue
            }
        } catch {}
    }

    Start-Sleep -Seconds 1
}

function Wait-FileUnlocked {
    param(
        [Parameter(Mandatory=$true)][string]$Path,
        [int]$TimeoutSeconds = 15
    )

    if (-not (Test-Path $Path)) { return $true }

    $deadline = (Get-Date).AddSeconds($TimeoutSeconds)

    while ((Get-Date) -lt $deadline) {
        try {
            $stream = [System.IO.File]::Open(
                $Path,
                [System.IO.FileMode]::Open,
                [System.IO.FileAccess]::ReadWrite,
                [System.IO.FileShare]::None
            )
            $stream.Close()
            return $true
        }
        catch {
            Start-Sleep -Milliseconds 500
        }
    }

    return $false
}

function Prepare-InstallFiles {
    Write-Host "      Stopping previous SteamFix runtime..."
    Stop-SteamFixRuntime

    $driver = Join-Path $BinDir "WinDivert64.sys"
    $dll    = Join-Path $BinDir "WinDivert.dll"
    $exe    = Join-Path $BinDir "goodbyedpi.exe"

    foreach ($file in @($driver,$dll,$exe)) {
        if ((Test-Path $file) -and -not (Wait-FileUnlocked -Path $file -TimeoutSeconds 15)) {
            throw "SteamFix could not update '$file' because it is still in use. Reboot Windows, then run Install again."
        }
    }
}

function Backup-Network {
    New-Item -ItemType Directory -Force -Path $Root | Out-Null

    $dnsBackup = Join-Path $Root "dns-backup.json"
    $dohBackup = Join-Path $Root "doh-backup.json"

    if (-not (Test-Path $dnsBackup)) {
        foreach ($candidate in @(
            (Join-Path $TestRoot "dns-backup.json"),
            (Join-Path $LegacyRoot "dns-backup.json")
        )) {
            if (Test-Path $candidate) {
                Copy-Item $candidate $dnsBackup -Force
                break
            }
        }
    }

    if (-not (Test-Path $dohBackup)) {
        $candidate = Join-Path $TestRoot "doh-backup.json"
        if (Test-Path $candidate) { Copy-Item $candidate $dohBackup -Force }
    }

    if (-not (Test-Path $dnsBackup)) {
        $adapters = @(Get-NetAdapter -Physical -ErrorAction SilentlyContinue |
            Where-Object { $_.Status -ne "Not Present" })

        if (-not $adapters) {
            $adapters = @(Get-NetAdapter -ErrorAction Stop | Where-Object { $_.Status -eq "Up" })
        }

        $backup = foreach ($a in $adapters) {
            $guid = ([string]$a.InterfaceGuid).Trim("{}")
            if ([string]::IsNullOrWhiteSpace($guid)) { continue }

            $reg = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\{$guid}"
            $p = Get-ItemProperty -LiteralPath $reg -ErrorAction SilentlyContinue
            $static = if ($null -ne $p -and $null -ne $p.NameServer) { [string]$p.NameServer } else { "" }

            [pscustomobject]@{
                InterfaceGuid   = $guid
                InterfaceAlias  = [string]$a.Name
                InterfaceIndex  = [int]$a.ifIndex
                StaticNameServer = $static
            }
        }

        if (-not $backup) { throw "No network adapters found." }
        $backup | ConvertTo-Json -Depth 5 | Set-Content -Encoding UTF8 $dnsBackup
    }

    if (-not (Test-Path $dohBackup)) {
        $hasDohCmdlet = [bool](Get-Command Get-DnsClientDohServerAddress -ErrorAction SilentlyContinue)
        if ($hasDohCmdlet) {
            $b = foreach ($ip in @("8.8.8.8","8.8.4.4")) {
                $x = Get-DnsClientDohServerAddress -ServerAddress $ip -ErrorAction SilentlyContinue
                if ($x) {
                    [pscustomobject]@{
                        ServerAddress      = $ip
                        Exists             = $true
                        DohTemplate        = [string]$x.DohTemplate
                        AllowFallbackToUdp = [bool]$x.AllowFallbackToUdp
                        AutoUpgrade        = [bool]$x.AutoUpgrade
                    }
                } else {
                    [pscustomobject]@{
                        ServerAddress      = $ip
                        Exists             = $false
                        DohTemplate        = ""
                        AllowFallbackToUdp = $false
                        AutoUpgrade        = $false
                    }
                }
            }
            $b | ConvertTo-Json -Depth 4 | Set-Content -Encoding UTF8 $dohBackup
        }
    }
}

function Enable-SecureDns {
    $hasDohCmdlet = [bool](Get-Command Get-DnsClientDohServerAddress -ErrorAction SilentlyContinue)

    if ($hasDohCmdlet) {
        $servers = @(
            @{ IP="8.8.8.8"; URL="https://dns.google/dns-query" },
            @{ IP="8.8.4.4"; URL="https://dns.google/dns-query" }
        )

        foreach ($s in $servers) {
            $x = Get-DnsClientDohServerAddress -ServerAddress $s.IP -ErrorAction SilentlyContinue
            if ($x) {
                Set-DnsClientDohServerAddress -ServerAddress $s.IP -DohTemplate $s.URL `
                    -AllowFallbackToUdp $false -AutoUpgrade $true -ErrorAction SilentlyContinue | Out-Null
            } else {
                Add-DnsClientDohServerAddress -ServerAddress $s.IP -DohTemplate $s.URL `
                    -AllowFallbackToUdp $false -AutoUpgrade $true -ErrorAction SilentlyContinue | Out-Null
            }
        }
    } else {
        Write-Host "      [!] Windows DoH cmdlets not supported on this Windows build. Falling back to Google DNS (UDP/TCP)." -ForegroundColor Yellow
    }

    $adapters = @(Get-NetAdapter -Physical -ErrorAction SilentlyContinue |
        Where-Object { $_.Status -eq "Up" })

    if (-not $adapters) { throw "No active physical network adapter found." }

    foreach ($a in $adapters) {
        Set-DnsClientServerAddress -InterfaceIndex $a.ifIndex `
            -ServerAddresses @("8.8.8.8","8.8.4.4")
    }
}

function Restore-Network {
    $dnsBackup = Join-Path $Root "dns-backup.json"
    $dohBackup = Join-Path $Root "doh-backup.json"

    if (Test-Path $dnsBackup) {
        $data = @(Get-Content -Raw $dnsBackup | ConvertFrom-Json)
        foreach ($entry in $data) {
            $wanted = ([string]$entry.InterfaceGuid).Trim("{}")
            $adapter = Get-NetAdapter -ErrorAction SilentlyContinue |
                Where-Object { (([string]$_.InterfaceGuid).Trim("{}")) -ieq $wanted } |
                Select-Object -First 1

            if (-not $adapter) { continue }

            $static = ""
            if ($entry.PSObject.Properties.Name -contains "StaticNameServer") {
                $static = [string]$entry.StaticNameServer
            } elseif ($entry.PSObject.Properties.Name -contains "NameServer") {
                $static = [string]$entry.NameServer
            }

            if ([string]::IsNullOrWhiteSpace($static)) {
                Set-DnsClientServerAddress -InterfaceIndex $adapter.ifIndex `
                    -ResetServerAddresses -ErrorAction SilentlyContinue
            } else {
                $servers = @($static -split '[,\s]+' | Where-Object { $_ })
                if ($servers.Count -gt 0) {
                    Set-DnsClientServerAddress -InterfaceIndex $adapter.ifIndex `
                        -ServerAddresses $servers -ErrorAction SilentlyContinue
                }
            }
        }
    }

    if (Test-Path $dohBackup) {
        $data = @(Get-Content -Raw $dohBackup | ConvertFrom-Json)
        foreach ($x in $data) {
            if ([bool]$x.Exists) {
                Set-DnsClientDohServerAddress `
                    -ServerAddress ([string]$x.ServerAddress) `
                    -DohTemplate ([string]$x.DohTemplate) `
                    -AllowFallbackToUdp ([bool]$x.AllowFallbackToUdp) `
                    -AutoUpgrade ([bool]$x.AutoUpgrade) `
                    -ErrorAction SilentlyContinue | Out-Null
            } elseif (Get-Command Remove-DnsClientDohServerAddress -ErrorAction SilentlyContinue) {
                Remove-DnsClientDohServerAddress `
                    -ServerAddress ([string]$x.ServerAddress) `
                    -ErrorAction SilentlyContinue | Out-Null
            }
        }
    }

    Clear-DnsClientCache -ErrorAction SilentlyContinue
}

function Install-GoodbyeDpi {
    New-Item -ItemType Directory -Force -Path $Root,$App,$BinDir | Out-Null

    $zip = Join-Path $env:TEMP "goodbyedpi-0.2.2.zip"
    $tmp = Join-Path $env:TEMP "SteamFixExtract"

    if (-not (Test-Path $Exe)) {
        Write-Host "[3/6] Downloading GoodbyeDPI 0.2.2..."
        $ProgressPreference = "SilentlyContinue"
        Invoke-WebRequest -UseBasicParsing -Uri $ZipUrl -OutFile $zip

        $f = Get-Item $zip
        if ($f.Length -ne $ZipSize) { throw "Unexpected GoodbyeDPI file size." }

        $hash = (Get-FileHash -Algorithm SHA256 $zip).Hash.ToLowerInvariant()
        if ($hash -ne $ZipSha256) { throw "GoodbyeDPI SHA-256 verification failed." }

        Remove-Item $tmp -Recurse -Force -ErrorAction SilentlyContinue
        Expand-Archive -LiteralPath $zip -DestinationPath $tmp -Force

        $archiveRoot = Get-ChildItem $tmp -Directory |
            Where-Object { $_.Name -like "goodbyedpi-*" } |
            Select-Object -First 1

        if (-not $archiveRoot) { throw "Unexpected GoodbyeDPI archive layout." }

        $src = Join-Path $archiveRoot.FullName "x86_64"
        foreach ($name in @("goodbyedpi.exe","WinDivert.dll","WinDivert64.sys")) {
            if (-not (Test-Path (Join-Path $src $name))) {
                throw "Missing $name in GoodbyeDPI archive."
            }
        }

        try {
            Copy-Item (Join-Path $src "*") $BinDir -Recurse -Force
        }
        catch {
            throw "Failed to update GoodbyeDPI/WinDivert files: $($_.Exception.Message)"
        }
        Remove-Item $tmp -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item $zip -Force -ErrorAction SilentlyContinue
    }

}

function Install-Service {
    # Previous SteamFix runtime was already stopped before files were updated.
    $binPath = '"' + $Exe + '" -f 2 -e 2 --auto-ttl --reverse-frag'

    New-Service -Name $ServiceName `
        -BinaryPathName $binPath `
        -DisplayName "SteamFix" `
        -Description "Steam DNS and global DPI access helper" `
        -StartupType Automatic | Out-Null

    # Automatic recovery if GoodbyeDPI exits unexpectedly.
    & sc.exe failure $ServiceName reset= 0 actions= restart/5000/restart/5000/restart/5000 | Out-Null

    Start-Service $ServiceName
    Start-Sleep -Seconds 2

    $svc = Get-Service $ServiceName
    if ($svc.Status -ne "Running") {
        throw "steamfix service did not enter RUNNING state."
    }
}

function Install-SteamFix {
    Ensure-Admin "Install"

    Write-Host ""
    Write-Host "============================================"
    Write-Host "      SteamFix Install - ZeroMem Studio" -ForegroundColor Cyan
    Write-Host "============================================"
    Write-Host ""

    Write-Host "[1/6] Backing up network configuration..."
    Backup-Network

    # If the successful no-service test is still running, stop it only
    # after importing its original DNS backups.
    Stop-TestProcess

    # Stop any previous SteamFix service/process and wait for WinDivert
    # to release its files before updating the installation.
    Prepare-InstallFiles

    Write-Host "[2/6] Enabling Google DNS-over-HTTPS..."
    Enable-SecureDns

    try {
        Install-GoodbyeDpi

        Write-Host "[4/6] Preparing global DPI bypass..."

        Write-Host "[5/6] Installing automatic Windows service..."
        Install-Service

        Write-Host "[6/6] Finishing..."
        Clear-DnsClientCache -ErrorAction SilentlyContinue

        @"
Version=1.1
Service=steamfix
Mode=AlwaysOn
Filter=Global
"@ | Set-Content -Encoding ASCII (Join-Path $Root "state.ini")

        Remove-Item $TestRoot -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item $TestApp -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item $LegacyRoot -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item $LegacyApp -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item (Join-Path $Root "steam-domains.txt") -Force -ErrorAction SilentlyContinue

        Write-Host ""
        Write-Host "SteamFix installed successfully."
        Write-Host "Service: steamfix"
        Write-Host "Startup: Automatic"
        Write-Host "DPI mode: Global"
        Write-Host ""
    }
    catch {
        Write-Host ""
        Write-Host "Installation failed: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host "Rolling back network changes..."

        Stop-OwnedService $ServiceName
        Restore-Network
        throw
    }
}

function Uninstall-SteamFix {
    Ensure-Admin "Uninstall"

    Write-Host ""
    Write-Host "============================================"
    Write-Host "     SteamFix Uninstall - ZeroMem Studio" -ForegroundColor Cyan
    Write-Host "============================================"
    Write-Host ""

    Write-Host "[1/3] Removing service..."
    Stop-OwnedService $ServiceName
    Stop-OwnedService "SteamEvoFix"

    Write-Host "[2/3] Restoring original network settings..."
    Restore-Network

    Write-Host "[3/3] Removing files..."
    Remove-Item $App -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item $Root -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item $TestApp -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item $TestRoot -Recurse -Force -ErrorAction SilentlyContinue

    Clear-DnsClientCache -ErrorAction SilentlyContinue
    Write-Host "SteamFix removed successfully."
}

function Refresh-Network {
    Ensure-Admin "Refresh"

    Write-Host ""
    Write-Host "============================================"
    Write-Host "   SteamFix Network Refresh - ZeroMem Studio" -ForegroundColor Cyan
    Write-Host "============================================"
    Write-Host ""

    Write-Host "[1/4] Restarting SteamFix service..."
    $svc = Get-Service $ServiceName -ErrorAction SilentlyContinue
    if ($svc) {
        Restart-Service -Name $ServiceName -Force -ErrorAction Stop
        Start-Sleep -Seconds 1
    } else {
        Write-Host "      SteamFix service is not installed."
    }

    Write-Host "[2/4] Flushing DNS cache..."
    Clear-DnsClientCache -ErrorAction SilentlyContinue
    & ipconfig.exe /flushdns | Out-Null

    Write-Host "[3/4] Clearing ARP cache..."
    & netsh.exe interface ip delete arpcache | Out-Null

    Write-Host "[4/4] Re-registering DNS..."
    & ipconfig.exe /registerdns | Out-Null

    Write-Host ""
    Write-Host "Network refresh complete."
}

function Show-Status {
    $svc = Get-Service $ServiceName -ErrorAction SilentlyContinue
    Write-Host ""
    Write-Host "SteamFix Status (ZeroMem Studio - https://zeromem.indevs.in/)" -ForegroundColor Cyan
    Write-Host "---------------"
    if ($svc) {
        Write-Host ("Service : " + $svc.Status)
        $svcInfo = Get-CimInstance Win32_Service -Filter "Name='$ServiceName'"
        Write-Host ("Startup : " + $svcInfo.StartMode)
        Write-Host ("Binary  : " + $svcInfo.PathName)
    } else {
        Write-Host "Service : Not installed"
    }
    Write-Host "DPI mode : Global"
    Write-Host ""
}

function Show-MainMenu {
    Clear-Host
    Write-Host "============================================"
    Write-Host "          SteamFix by ZeroMem Studio" -ForegroundColor Cyan
    Write-Host "          https://zeromem.indevs.in/" -ForegroundColor DarkGray
    Write-Host "============================================"
    Write-Host ""
    Write-Host "1. Install"
    Write-Host "2. Uninstall"
    Write-Host "3. Check status"
    Write-Host "4. Refresh network"
    Write-Host "0. Exit"
    Write-Host ""

    while ($true) {
        $choice = Read-Host "Select an option"

        switch ($choice) {
            "1" { return "Install" }
            "2" { return "Uninstall" }
            "3" { return "Status" }
            "4" { return "Refresh" }
            "0" { return "Exit" }
            default {
                Write-Host "Invalid option. Enter 1, 2, 3, 4, or 0." -ForegroundColor Yellow
            }
        }
    }
}

function Invoke-SteamFixAction {
    param([string]$SelectedAction)

    switch ($SelectedAction.ToLowerInvariant()) {
        "install"   { Install-SteamFix }
        "uninstall" { Uninstall-SteamFix }
        "status"    { Show-Status }
        "refresh"   { Refresh-Network }
        "exit"      { return }
        default     { throw "Unknown action: $SelectedAction" }
    }
}

function Show-SteamFixError {
    param($ErrorRecord)

    Write-Host ""
    Write-Host "============================================" -ForegroundColor Red
    Write-Host "              STEAMFIX ERROR" -ForegroundColor Red
    Write-Host "============================================" -ForegroundColor Red
    Write-Host ""
    Write-Host $ErrorRecord.Exception.Message -ForegroundColor Red
    Write-Host ""

    if ($ErrorRecord.ScriptStackTrace) {
        Write-Host $ErrorRecord.ScriptStackTrace
        Write-Host ""
    }
}

if ([string]::IsNullOrWhiteSpace($Action)) {
    while ($true) {
        $selected = Show-MainMenu

        if ($selected -eq "Exit") {
            break
        }

        try {
            Invoke-SteamFixAction $selected
        }
        catch {
            Show-SteamFixError $_
        }

        Write-Host ""
        Read-Host "Press Enter to return to the menu"
    }
}
else {
    try {
        Invoke-SteamFixAction $Action
    }
    catch {
        Show-SteamFixError $_
    }

    Write-Host ""
    Read-Host "Press Enter to close"
}
