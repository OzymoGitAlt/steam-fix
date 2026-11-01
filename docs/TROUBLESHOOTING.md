# Troubleshooting Guide / Hướng Dẫn Khắc Phục Sự Cố

This guide helps troubleshoot connectivity and execution issues when using SteamFix.

---

## Table of Contents / Mục Lục

1. [Steam is blocked in Vietnam / Steam bị chặn tại Việt Nam](#steam-is-blocked-in-vietnam--steam-b%E1%BB%8B-ch%E1%BA%B7n-t%E1%BA%A1i-vi%E1%BB%87t-nam)
2. [Steam Store not loading / Steam Store không vào được](#steam-store-not-loading--steam-store-kh%C3%B4ng-v%C3%A0o-%C4%91%C6%B0%E1%BB%A3c)
3. [Steam Community not loading / Steam Community không load](#steam-community-not-loading--steam-community-kh%C3%B4ng-load)
4. [CS2 avatars not loading / CS2 không load avatar](#cs2-avatars-not-loading--cs2-kh%C3%B4ng-load-avatar)
5. [Steam avatars not loading / Steam avatar không hiện](#steam-avatars-not-loading--steam-avatar-kh%C3%B4ng-hi%E1%BB%87n)
6. [Steam downloads not working / Steam tải game lỗi](#steam-downloads-not-working--steam-t%E1%BA%A3i-game-l%E1%BB%97i)
7. [Steam CDN connection failed / Steam CDN bị chặn](#steam-cdn-connection-failed--steam-cdn-b%E1%BB%8B-ch%E1%BA%B7n)
8. [PUBG stuck loading due to network / PUBG treo loading do mạng](#pubg-stuck-loading-due-to-network--pubg-treo-loading-do-m%E1%BA%A1ng)
9. [Website blocked by ISP / Web bị nhà mạng chặn](#website-blocked-by-isp--web-b%E1%BB%8B-nh%C3%A0-m%E1%BA%A1ng-ch%E1%BA%B7n)
10. [DNS poisoning / DNS nhà mạng trả sai IP](#dns-poisoning--dns-nh%C3%A0-m%E1%BA%A1ng-tr%E1%BA%A3-sai-ip)
11. [SNI / DPI blocking / DPI và SNI chặn kết nối HTTPS](#sni--dpi-blocking--dpi-v%C3%A0-sni-ch%E1%BA%B7n-k%E1%BA%BFt-n%E1%BB%91i-https)
12. [WinDivert64.sys is in use / Lỗi file WinDivert bị khóa](#windivert64sys-is-in-use--l%E1%BB%97i-file-windivert-b%E1%BB%8B-kh%C3%B3a)
13. [SteamFix service failed to start / Service steamfix không khởi động được](#steamfix-service-failed-to-start--service-steamfix-kh%C3%B4ng-kh%E1%BB%9Fi-%C4%91%E1%BB%99ng-%C4%91%C6%B0%E1%BB%A3c)
14. [PowerShell script is not digitally signed / Lỗi script chưa ký số](#powershell-script-is-not-digitally-signed--l%E1%BB%97i-script-ch%C6%B0a-k%C3%BD-s%E1%BB%91)
15. [ExecutionPolicy blocked the script / Bị chặn bởi ExecutionPolicy](#executionpolicy-blocked-the-script--b%E1%BB%8B-ch%E1%BA%B7n-b%E1%BB%9Fi-executionpolicy)
16. [VPN conflict / Xung đột phần mềm VPN](#vpn-conflict--xung-%C4%91%E1%BB%99t-ph%E1%BA%A7n-m%E1%BB%81m-vpn)

---

### Steam is blocked in Vietnam / Steam bị chặn tại Việt Nam

- **Symptom**: Steam client loads an error screen (`Error -101`, `Error -105`, or connection timeout) when attempting to open the Store or Community page.
- **Cause**: The local ISP DNS resolver either returns invalid addresses (DNS poisoning) or the ISP's equipment performs Deep Packet Inspection (DPI) to reset TCP/TLS connections targeting Steam SNI hostnames.
- **Solution**:
  1. Run SteamFix installer (`Option 1`).
  2. Select `Option 4: Refresh network` or reboot your computer.
  3. Fully restart the Steam client (Exit from system tray and reopen).

---

### Steam Store not loading / Steam Store không vào được

- **Symptom**: Steam Store is a blank grey window or displays `Error Code: -105 Unable to connect to server`.
- **Cause**: Blocked DNS lookup or dropped TLS handshake when negotiating connections with `store.steampowered.com`.
- **Solution**: Run SteamFix to enable Google DNS-over-HTTPS and activate GoodbyeDPI packet fragmentation. In Steam, navigate to `Settings > In Game > Delete Web Browser Data` if cached errors persist.

---

### Steam Community not loading / Steam Community không load

- **Symptom**: Discussions, Workshop, user inventory, and Market display connection errors.
- **Cause**: DPI filters intercepting requests to `steamcommunity.com`.
- **Solution**: Install SteamFix. GoodbyeDPI fragments TLS Client Hello packets (`-f 2 -e 2 --reverse-frag`), preventing DPI inspection devices from detecting the target SNI.

---

### CS2 avatars not loading / CS2 không load avatar

- **Symptom**: In Counter-Strike 2 (CS2), teammates' and opponents' Steam profile avatars appear as blank default question marks or grey squares.
- **Cause**: In-game avatar fetching makes HTTPS requests to Steam's content delivery network (CDN) domain (`avatars.cloudflare.steamstatic.com` / `avatars.steamstatic.com`). When ISP filters block or throttle these domains, the game client times out.
- **Solution**: Run SteamFix. Once the network is refreshed, restart CS2. Note: If CS2 is experiencing game coordinator or matchmaking downtime, that is a Valve server issue outside SteamFix's scope.

---

### Steam avatars not loading / Steam avatar không hiện

- **Symptom**: In the Steam Friends list and profile view, friend profile pictures fail to load.
- **Cause**: CDN endpoints for image caching are filtered by the network provider.
- **Solution**: Apply SteamFix. Refresh network cache using `Option 4`.

---

### Steam downloads not working / Steam tải game lỗi

- **Symptom**: Game downloads start and immediately stall at 0 bps, or fail with `Content servers unreachable` / `Connection timed out`.
- **Cause**: ISP routing or DNS tampering preventing the Steam client from resolving or connecting to selected Steam download CDN servers.
- **Solution**:
  1. Install SteamFix.
  2. In Steam Settings, go to `Downloads > Download Region` and switch to a nearby region (e.g., Vietnam - Hanoi, Vietnam - HCMC, or Singapore).
  3. Restart Steam.

---

### Steam CDN connection failed / Steam CDN bị chặn

- **Symptom**: Static assets, workshop images, or patch manifests fail to download.
- **Cause**: Subdomains of `steamstatic.com` and `steamcontent.com` are intercepted by ISP DPI.
- **Solution**: SteamFix resolves CDN hostnames through encrypted DNS-over-HTTPS and fragments outgoing handshake packets to bypass ISP middleboxes.

---

### PUBG stuck loading due to network / PUBG treo loading do mạng

- **Symptom**: PlayerUnknown's Battlegrounds (PUBG) hangs indefinitely on the initial loading/connecting screen, or displays connection timeout prompts before reaching the main lobby.
- **Cause**: Certain game lobby backend endpoints, authentication CDN servers, or cloud microservices are blocked or throttled by ISP DNS/DPI filtering.
- **Solution**: Run SteamFix to ensure your network can resolve and establish TLS handshakes with affected game services.
- **Important Qualification**: SteamFix **only** helps when PUBG connectivity issues stem from ISP DNS/DPI filtering. It **cannot** fix graphical rendering issues, smoke grenade visual bugs, shader compilation hitches, corrupted game files, or BattlEye/PUBG server maintenance outages.

---

### Website blocked by ISP / Web bị nhà mạng chặn

- **Symptom**: Standard web browsers fail to open specific gaming forums, wikis, or foreign websites.
- **Cause**: ISP DNS blocking or SNI inspection.
- **Solution**: Because GoodbyeDPI operates as a system service globally, SteamFix provides system-wide DPI evasion for web browsers (Chrome, Edge, Firefox) without needing a proxy.

---

### DNS poisoning / DNS nhà mạng trả sai IP

- **Symptom**: Looking up a domain with standard `nslookup` returns `127.0.0.1`, `0.0.0.0`, or an ISP blocking landing page.
- **Cause**: The ISP's default resolver deliberately provides forged DNS replies.
- **Solution**: SteamFix configures Google DNS (`8.8.8.8` / `8.8.4.4`) with native Windows DNS-over-HTTPS (DoH), encrypting queries over HTTPS so the ISP cannot forge replies.

---

### SNI / DPI blocking / DPI và SNI chặn kết nối HTTPS

- **Symptom**: DNS resolves to valid external IPs, but the browser or Steam times out during the TLS handshake ("Connection reset by peer").
- **Cause**: The ISP inspects the plaintext Server Name Indication (SNI) in the TLS Client Hello and sends TCP RST packets to kill the connection.
- **Solution**: GoodbyeDPI fragments the Client Hello packets into multiple TCP segments (`-f 2 -e 2 --auto-ttl --reverse-frag`). Most ISP DPI boxes cannot reassemble out-of-order or reverse-fragmented packets, allowing the handshake to complete securely.

---

### WinDivert64.sys is in use / Lỗi file WinDivert bị khóa

- **Symptom**: SteamFix installer outputs: `SteamFix could not update '...WinDivert64.sys' because it is still in use.`
- **Cause**: A running instance of GoodbyeDPI, SteamFix, or another WinDivert application holds an open kernel handle to the driver.
- **Solution**:
  1. Open Task Manager and terminate any running `goodbyedpi.exe` processes.
  2. If the kernel driver is still latched, restart Windows and immediately run SteamFix again.

---

### SteamFix service failed to start / Service steamfix không khởi động được

- **Symptom**: Service installation reports `steamfix service did not enter RUNNING state`.
- **Cause**: Antivirus software (third-party security suites) blocking WinDivert driver loading, or driver signature enforcement conflicts.
- **Solution**:
  1. Verify if an aggressive third-party antivirus is blocking WinDivert.
  2. Run `sc.exe query steamfix` from an elevated terminal to check the service status.
  3. Run `Option 4: Refresh network` or reboot Windows.

---

### PowerShell script is not digitally signed / Lỗi script chưa ký số

- **Symptom**: `File SteamFix.ps1 cannot be loaded because running scripts is disabled on this system.` or `not digitally signed`.
- **Cause**: Default Windows client PowerShell execution policy (`Restricted`).
- **Solution**: Launch PowerShell with process-scoped bypass (does not affect system security permanently):
  ```powershell
  powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\SteamFix.ps1
  ```
  Or run via one-command launcher:
  ```powershell
  powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "irm 'https://raw.githubusercontent.com/ZeroMemInc/steam-fix/main/SteamFix.ps1' | iex"
  ```

---

### ExecutionPolicy blocked the script / Bị chặn bởi ExecutionPolicy

- **Symptom**: Execution is stopped by enterprise group policy or user execution policy.
- **Solution**: Use `-ExecutionPolicy Bypass` as documented above. The flag only applies to that specific process and terminates when the window closes.

---

### VPN conflict / Xung đột phần mềm VPN

- **Symptom**: Disconnecting or connecting to a commercial VPN (e.g., WARP, NordVPN, ExpressVPN) causes network drops while SteamFix is running.
- **Cause**: Both the VPN TAP/Wintun adapter and WinDivert attempt to intercept and reroute network packets simultaneously.
- **Solution**:
  - While using a full-tunnel VPN, SteamFix is usually not necessary (the VPN handles DNS and encryption).
  - If you encounter network conflicts, run `Option 2: Uninstall` in SteamFix before connecting to your VPN, or select `Option 4: Refresh network` after disconnecting.
