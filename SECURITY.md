# Security Policy

## Overview

SteamFix operates strictly as a local network configuration and packet-formatting utility. It does not tamper with game executables, Steam binaries, game memory, or user credentials.

---

## Security Model & Design Principles

1. **Administrator Privileges**
   - Administrator rights are required strictly to configure Windows network adapter DNS settings, register DNS-over-HTTPS templates via Windows native cmdlets, and install/control the background Windows service (`steamfix`).
   - SteamFix does not install unauthorized background drivers outside of GoodbyeDPI's signed WinDivert driver.

2. **Package & Binary Integrity**
   - SteamFix downloads the official GoodbyeDPI release zip archive directly from the GitHub repository (`https://github.com/ValdikSS/GoodbyeDPI/releases/download/0.2.2/goodbyedpi-0.2.2.zip`).
   - Prior to extraction, the archive's exact file length and SHA-256 cryptographic hash (`00a2f8b99cd817f8c7fc4c449033015f039d18af213de78cb66bf202277c0628`) are strictly verified. If any mismatch occurs, installation aborts immediately.

3. **Zero Telemetry & Absolute Privacy**
   - SteamFix contains **zero telemetry**, tracking pixels, analytics, or remote logging.
   - Steam credentials, account names, passwords, tokens, Steam Guard keys, and payment details are **never collected, inspected, or transmitted**.

4. **No Process or Binary Tampering**
   - SteamFix **does not modify** any files in the Steam installation directory (`Steam.exe`, DLLs, VDF files, cache).
   - SteamFix **does not modify** any game executables or files.
   - SteamFix **does not inject DLLs** or manipulate memory of game processes or the Steam client.
   - SteamFix **does not attempt anti-cheat bypass** (e.g., Valve Anti-Cheat / VAC, BattlEye, Easy Anti-Cheat). It operates at the network stack.

5. **Transparency & Inspection**
   - We encourage all users to inspect the script before running it with elevated privileges:
     ```powershell
     Invoke-WebRequest 'https://raw.githubusercontent.com/ZeroMemInc/steam-fix/main/SteamFix.ps1' -OutFile SteamFix.ps1
     notepad SteamFix.ps1
     ```

---

## Reporting Vulnerabilities

If you discover a security vulnerability or bug in the SteamFix automation script, please open an issue on the GitHub repository issue tracker with reproduction details.
