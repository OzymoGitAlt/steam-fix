# SteamFix

SteamFix is an open-source Windows network utility designed to help with Steam, game launcher and website connectivity problems caused by DNS poisoning, DNS filtering, DPI or SNI filtering. It combines secure DNS with GoodbyeDPI and can help restore Steam Store, Steam Community, profile avatars, Steam CDN access and game downloads on affected networks.

---

## What is SteamFix?

SteamFix helps Windows users when Steam Store or Steam Community fails because an ISP is poisoning DNS responses or filtering TLS/SNI traffic. By orchestrating Windows-native **DNS-over-HTTPS (DoH)** and the battle-tested **GoodbyeDPI** engine as an automatic background Windows service (`steamfix`), SteamFix resolves connectivity issues at the packet level without requiring VPN tunnels, paid proxies, or third-party accounts.

SteamFix operates entirely on network-layer packets:
- **No modification to Steam binaries** (`Steam.exe` and game files remain 100% untouched).
- **No game injection or memory manipulation**.
- **No anti-cheat bypass mechanisms** (fully compatible with VAC, BattlEye, and EAC).
- **Zero telemetry**, zero logging, and complete user privacy.

---

## Features

- **Automated DNS-over-HTTPS (DoH)**: Configures Google Secure DNS (`8.8.8.8` / `8.8.4.4`) with strict HTTPS encryption to eliminate ISP DNS poisoning.
- **Deep Packet Inspection (DPI) Circumvention**: Deploys GoodbyeDPI with proven anti-censorship parameters (`-f 2 -e 2 --auto-ttl --reverse-frag`) to fragment TLS Client Hello SNI headers.
- **Native Windows Service**: Runs silently in the background as the `steamfix` service with automatic start-on-boot and crash auto-recovery.
- **Clean Interactive Console**: User-friendly menu for 1-click Install, Uninstall, Status checking, and Network cache flushing.
- **Safe Network Backups**: Backs up your active network adapter DNS and DoH configurations before making changes, ensuring 100% clean restoration upon uninstallation.
- **WinDivert Lock Protection**: Automatically terminates previous instances and handles driver file unlock timeouts gracefully.
- **Zero Telemetry**: No tracking, no external data collection, and no custom root certificates required.

---

## Quick Install

### One-Command Launcher (Fastest)

Launch an elevated PowerShell terminal or standard PowerShell prompt and run:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "irm 'https://raw.githubusercontent.com/OzymoGit/SteamFix/main/SteamFix.ps1' | iex"
```

> [!NOTE]
> The `-ExecutionPolicy Bypass` argument applies **only** to that specific PowerShell process. It does not permanently change or weaken your machine's global PowerShell execution policy. If not running as Administrator, SteamFix will automatically prompt for elevation.

### Inspect-First Method (Recommended for Security)

If you prefer to inspect remote scripts before granting Administrator privileges:

```powershell
# 1. Download the script locally
Invoke-WebRequest 'https://raw.githubusercontent.com/OzymoGit/SteamFix/main/SteamFix.ps1' -OutFile SteamFix.ps1

# 2. Inspect the source code in your editor
notepad SteamFix.ps1

# 3. Run the script with process-scoped bypass
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\SteamFix.ps1
```

---

## Common Problems SteamFix Can Help With

SteamFix is specifically tailored for network-level filtering and connection failures. Below are typical issues and their natural descriptions:

### English

- **Steam Store does not load**: Blank pages or `Error -105` when browsing the store.
- **Steam Community does not open**: Discussions, Workshop, Inventories, or Market fail to connect.
- **Steam profile avatars do not load**: Profile pictures appear as grey boxes in friends list or client.
- **CS2 cannot load Steam avatars**: Counter-Strike 2 in-game scoreboard displays default placeholders instead of real avatars.
- **Steam CDN requests fail**: Workshop downloads or game updates fail or stop abruptly.
- **Steam game downloads fail or stall**: Download speed drops to 0 bps due to connection resets on content delivery servers.
- **Steam-related images/assets do not appear**: Store banners, screenshots, or game icons fail to fetch.
- **A game cannot retrieve Steam profile images**: Third-party games integrating Steamworks fail to pull profile pictures.
- **A launcher or game hangs while contacting filtered CDN/API endpoints**: PUBG, EA App, or other game launchers hanging at connection/login screens due to filtered endpoints.
- **Websites blocked by ISP DNS/DPI filtering**: General web browsing hindered by middlebox SNI blocking.

### Tiếng Việt (Vietnamese)

- **Steam bị chặn**: Không thể kết nối tới máy chủ Steam trên mạng internet Việt Nam.
- **Steam Store không vào được**: Cửa hàng Steam báo lỗi kết nối hoặc màn hình đen.
- **Steam Community không load**: Chợ cộng đồng, kho đồ, và Steam Workshop không thể hiển thị.
- **Steam avatar không hiện**: Avatar bạn bè và trang cá nhân không load được hình ảnh.
- **CS2 không load avatar**: Counter-Strike 2 không hiện avatar của đồng đội và đối thủ trong trận đấu.
- **Game không tải được avatar Steam**: Các tựa game kết nối Steam API bị lỗi tải thông tin profile.
- **Steam tải game lỗi**: Tải game bị đứng ở 0 bytes/s hoặc báo `Content servers unreachable`.
- **Steam download bị đứng**: Tắc nghẽn kết nối do CDN tải game bị chặn gói tin.
- **Steam CDN bị chặn**: Không thể tải dữ liệu ảnh, tài nguyên game từ hệ thống máy chủ CDN Steam.
- **PUBG treo ở bước kết nối do mạng/CDN bị chặn**: PUBG bị kẹt ở màn hình loading ban đầu khi kết nối sảnh chờ do CDN/API bị nhà mạng chặn.
- **PUBG không vào được nếu nguyên nhân là DNS/DPI của nhà mạng**: Khắc phục lỗi kết nối PUBG khi nguyên nhân xuất phát từ lọc gói tin ISP.
- **Web bị nhà mạng chặn**: Các trang web thông thường bị chặn qua DNS hoặc kiểm duyệt SNI.
- **DNS nhà mạng trả sai IP**: Nhà mạng thực hiện đầu độc DNS (DNS poisoning), trả về IP không hợp lệ.
- **DPI/SNI chặn kết nối HTTPS**: Nhà mạng sử dụng Deep Packet Inspection để ngắt kết nối HTTPS khi nhận diện tên miền Steam.

> [!IMPORTANT]
> **Scope Boundary**: SteamFix cannot fix unrelated GPU, rendering, corrupted game files, anti-cheat, server outage or hardware problems. For instance:
> - CS2 avatars failing to load due to blocked Steam CDN endpoints **is** a valid use case.
> - PUBG hanging on the initial loading/connecting screen because required network endpoints are filtered **can be** a valid use case.
> - A PUBG graphical smoke rendering bug, visual artifact, low FPS, or game crash is **NOT** something SteamFix can fix.

---

## Vietnam ISP / Steam Blocking

In Vietnam, access to the Steam Store, Steam Community, and certain game CDN endpoints can become intermittently unstable or blocked. Some users on Vietnamese ISPs such as **FPT**, **VNPT** or **Viettel** (often colloquially referred to as "nhà mạng 3 chữ", "nhà mạng 4 chữ", or "nhà mạng 7 chữ") may encounter DNS or DPI filtering depending on location, routing and current ISP configuration.

ISP filtering in Vietnam typically operates at two technical layers:

1. **DNS Poisoning (Đầu độc DNS)**:
   - When your computer queries domain names like `store.steampowered.com` or `steamcommunity.com`, the ISP's default DNS server intercepts the query and returns an invalid IP (`127.0.0.1`, `0.0.0.0`, or a redirection IP).
   - *How SteamFix solves it*: SteamFix enables native Windows **DNS-over-HTTPS (DoH)** pointing to Google DNS (`8.8.8.8` / `8.8.4.4`). All DNS requests are encrypted over HTTPS, preventing ISP tampering.

2. **DPI / SNI Filtering (Kiểm duyệt gói tin sâu qua SNI)**:
   - Even when using clean DNS, the initial TLS handshake (the Client Hello packet) contains the target domain name in plaintext (Server Name Indication - SNI). Deep Packet Inspection equipment used by ISPs detects the hostname and immediately injects TCP RST packets to sever the connection.
   - *How SteamFix solves it*: SteamFix runs GoodbyeDPI to split and reverse-fragment the TLS Client Hello packets. Because the target hostname is broken across fragmented TCP segments, middlebox DPI appliances fail to match the filter rule and let the connection pass transparently.

> [!NOTE]
> Network conditions vary substantially across different geographical provinces, specific routers, DNS resolvers, and routing schedules. SteamFix provides a standardized, automated solution that works reliably across network environments.

---

## How It Works

```
[ Application / Game / Steam ]
             │
             ▼
   [ Windows DNS Client ] ──(HTTPS: encrypted query)──► [ Google DoH 8.8.8.8 ]
             │
             ▼ (Resolves correct IP)
   [ TCP/IP Network Stack ]
             │
             ▼ (WinDivert driver intercepts Client Hello)
    [ GoodbyeDPI Service ] ──(Fragments SNI: -f 2 -e 2 --auto-ttl --reverse-frag)
             │
             ▼
   [ ISP Middlebox / DPI ] ──(Unable to inspect fragmented SNI -> Passes traffic)
             │
             ▼
   [ Target Steam Server / Game CDN ] (Connection Established)
```

1. **Backup Phase**: Reads your existing DNS server configuration from the Windows Registry and exports it to `C:\ProgramData\SteamFix\dns-backup.json`.
2. **DNS Encryption**: Registers Google DoH template (`https://dns.google/dns-query`) and assigns `8.8.8.8` / `8.8.4.4` to active physical network adapters.
3. **GoodbyeDPI Verification**: Downloads the official release v0.2.2 zip from GitHub, verifies exact file length and SHA-256 checksum, then deploys binaries to `C:\Program Files\SteamFix\x86_64`.
4. **Service Installation**: Registers and starts the native Windows service `steamfix` with `-f 2 -e 2 --auto-ttl --reverse-frag`.

---

## Menu

Running `SteamFix.ps1` without arguments opens an interactive console menu:

```text
============================================
                 SteamFix
============================================

1. Install
2. Uninstall
3. Check status
4. Refresh network
0. Exit

Select an option:
```

- **`1. Install`**: Runs the complete installation pipeline (Backup -> DoH -> GoodbyeDPI verification -> Service creation).
- **`2. Uninstall`**: Stops and deletes the `steamfix` service, restores previous adapter DNS/DoH settings from backup, and removes application directories.
- **`3. Check status`**: Queries the Windows Service Control Manager to display whether the `steamfix` service is Running or Stopped, its startup mode, and binary path.
- **`4. Refresh network`**: Restarts the `steamfix` service, flushes the Windows DNS resolver cache (`ipconfig /flushdns`), clears the ARP cache, and re-registers DNS (`ipconfig /registerdns`).
- **`0. Exit`**: Exits the console interface.

You can also run specific actions non-interactively via the `-Action` parameter:
```powershell
powershell.exe -ExecutionPolicy Bypass -File .\SteamFix.ps1 -Action Install
powershell.exe -ExecutionPolicy Bypass -File .\SteamFix.ps1 -Action Uninstall
powershell.exe -ExecutionPolicy Bypass -File .\SteamFix.ps1 -Action Status
powershell.exe -ExecutionPolicy Bypass -File .\SteamFix.ps1 -Action Refresh
```

---

## Install

To install SteamFix:
1. Open PowerShell and run the one-command launcher.
2. Select `1` from the menu.
3. Once completed, restart the Steam client or launch your game.

---

## Uninstall

To cleanly remove SteamFix:
1. Run `SteamFix.ps1` and select `2` (Uninstall).
2. The script will:
   - Stop and delete the `steamfix` Windows service.
   - Revert DNS servers on physical network adapters to your original values (or DHCP if previously dynamic).
   - Restore DoH templates to their prior state.
   - Flush the DNS cache.
   - Remove installation files from `C:\Program Files\SteamFix` and `C:\ProgramData\SteamFix`.

---

## Check Status

Select `3` (Check status) to verify that the service is running. It checks:
- Service name: `steamfix`
- Status: `Running`
- Startup type: `Automatic`
- DPI mode: `Global`

---

## Refresh Network

If you experience network hiccups after switching Wi-Fi networks or resuming from sleep:
1. Select `4` (Refresh network).
2. It restarts the `steamfix` service, executes `ipconfig /flushdns`, clears the ARP cache with `netsh interface ip delete arpcache`, and re-registers DNS names with `ipconfig /registerdns`.

---

## What SteamFix Changes

SteamFix makes minimal, fully reversible system changes:
1. **Network Adapter DNS**: Sets primary DNS to `8.8.8.8` and secondary DNS to `8.8.4.4`.
2. **DNS-over-HTTPS Settings**: Registers `https://dns.google/dns-query` via `Set-DnsClientDohServerAddress` with UDP fallback disabled.
3. **Windows Service**: Installs a service named `steamfix` pointing to `C:\Program Files\SteamFix\x86_64\goodbyedpi.exe`.
4. **Filesystem**: Stores application binaries in `C:\Program Files\SteamFix` and state/backups in `C:\ProgramData\SteamFix`.

---

## Compatibility

- **Operating System**: Windows 11 (all editions) and Windows 10 (Version 2004 or newer with DoH support).
- **Architecture**: 64-bit (x64 / AMD64).
- **Antivirus / Anti-Cheat**: Compatible with VAC, BattlEye, Easy Anti-Cheat, and Riot Vanguard. WinDivert is a legitimate, signed packet capture driver.
- **VPN Notice**: See [Global GoodbyeDPI Disclosure](#explain-global-goodbyedpi) below for VPN interaction.

---

## Explain Global GoodbyeDPI

The current version of SteamFix runs GoodbyeDPI **globally**.

While the `steamfix` service is active, GoodbyeDPI network manipulation is **not process-limited to Steam**.

### Benefits
- SteamFix may help games or websites other than Steam when the same ISP-level DPI filtering is responsible for the connection problem because GoodbyeDPI currently runs globally.
- Web browsers (Chrome, Edge, Firefox, Brave) and other game launchers (EA, Epic Games, Riot) benefit from automatic SNI fragmentation.

### Potential Interactions
- **VPNs**: Using a full-tunnel VPN simultaneously may conflict with WinDivert packet interception. If you plan to connect to a VPN, uninstall or stop SteamFix first.
- **Packet filtering utilities**: Other WinDivert-based software (e.g., Zapret, Discord voice fixers) cannot share WinDivert handles simultaneously.

---

## Troubleshooting

For detailed troubleshooting steps, including errors like `WinDivert64.sys is in use` or `-105 Connection timed out`, please consult the dedicated [Troubleshooting Guide](docs/TROUBLESHOOTING.md).

---

## Privacy

SteamFix adheres to strict privacy standards:
- **No data collection**: No telemetry, analytics, or phone-home pings.
- **No credential access**: Does not inspect Steam tokens, login passwords, or local credentials.
- **Source availability**: The entire PowerShell script is open-source and human-readable.

---

## Security

Please review [SECURITY.md](SECURITY.md) for full security details:
- Runs with elevated privileges only for DNS and service management.
- Verifies SHA-256 integrity of downloaded binaries before execution.
- No DLL injection, memory patching, or binary tampering.

---

## FAQ

#### Is SteamFix a VPN?
No. SteamFix does not route your internet traffic through external remote servers. Your traffic goes directly to Steam servers and websites at your full native ISP speed and ping.

#### Does SteamFix modify Steam?
No. SteamFix does not touch, modify, patch, or alter any Steam client executable or game files.

#### Does SteamFix modify games?
No. Game executables and data archives remain completely unmodified.

#### Does SteamFix bypass anti-cheat?
No. SteamFix has nothing to do with anti-cheat software and does not interact with game processes or anti-cheat memory.

#### Can SteamFix help CS2 avatars load?
Yes, if the avatars fail because Steam image/CDN endpoints are being blocked by DNS or DPI filtering. It will not fix an unrelated CS2 bug or Valve matchmaking outage.

#### Can SteamFix help PUBG connect?
Possibly, if PUBG or its launcher is failing because required network endpoints are affected by the same DNS/DPI filtering. It cannot fix rendering, game file or server-side problems.

#### Can SteamFix unblock websites?
Yes. Because GoodbyeDPI operates globally, web traffic affected by ISP DPI or SNI blocking can pass transparently.

#### Does SteamFix work with FPT?
Yes. FPT users experiencing DNS or DPI drops to Steam Store or Community can use SteamFix to restore access.

#### Does SteamFix work with VNPT?
Yes. VNPT users facing DNS poisoning or SNI filtering on Steam assets can resolve it with SteamFix.

#### Does SteamFix work with Viettel?
Yes. Viettel connections affected by Steam CDN filtering are supported.

#### Why does it require Administrator?
Administrator privileges are required to configure Windows network adapter DNS settings, register DNS-over-HTTPS templates, and create the background `steamfix` Windows service.

#### Why does it use ExecutionPolicy Bypass?
PowerShell on Windows defaults to `Restricted` mode, blocking local script execution. The `-ExecutionPolicy Bypass` parameter only affects that single PowerShell invocation and does not change your system-wide security settings.

#### Does GoodbyeDPI run globally?
Yes, GoodbyeDPI runs as a global Windows service, providing DPI circumvention for all applications on the machine.

#### Can SteamFix conflict with a VPN?
Yes, running GoodbyeDPI and a VPN simultaneously can sometimes cause conflicts because both tools attempt to filter network packets. We recommend uninstalling SteamFix if you use a full-tunnel VPN.

#### Can I uninstall everything?
Yes. Option 2 in the menu completely deletes the service, removes all files, and restores your previous DNS configuration.

#### Will DNS be restored?
Yes. SteamFix takes a snapshot of your network adapter settings before making changes and restores them during uninstallation.

#### Is this affiliated with Valve?
No. SteamFix is an independent open-source project and is not affiliated with, endorsed by, or associated with Valve Corporation, Steam, PUBG Corporation, or any Internet Service Provider.

---

## GoodbyeDPI Attribution

SteamFix bundles and automates [GoodbyeDPI](https://github.com/ValdikSS/GoodbyeDPI) by ValdikSS and the [WinDivert](https://github.com/basil00/Divert) driver by basil00. See [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md) for full licensing information.

---

## License

This project is licensed under the [MIT License](LICENSE). Third-party components retain their respective licenses.

---

## Disclaimer

SteamFix is provided "as is" without warranty of any kind. Steam, Counter-Strike 2 (CS2), PUBG, Valve, FPT, VNPT, and Viettel are trademarks or registered trademarks of their respective owners. SteamFix is not affiliated with or endorsed by any of these entities.
