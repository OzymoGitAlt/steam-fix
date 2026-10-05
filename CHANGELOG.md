# Changelog

All notable changes to the SteamFix project are documented in this file.

---

## [1.0.0] - 2026-10-05

### Added
- **Interactive PowerShell Console Menu**:
  - `1. Install`: Automated backup, DoH configuration, GoodbyeDPI verification, and service installation.
  - `2. Uninstall`: Service removal and restoration of previous DNS settings from backup.
  - `3. Check status`: Query Windows service state, startup mode, and binary path.
  - `4. Refresh network`: Flush DNS cache (`ipconfig /flushdns`), clear ARP cache, re-register DNS, and restart service.
  - `0. Exit`.
- **Google DNS-over-HTTPS (DoH)**:
  - Automatic configuration of Google DoH (`8.8.8.8` / `8.8.4.4` via `https://dns.google/dns-query`).
  - Native Windows DoH template registration with fallback prevention.
- **GoodbyeDPI Integration**:
  - Automated download of official GoodbyeDPI release v0.2.2.
  - Cryptographic SHA-256 hash and exact file length validation.
  - Tested anti-censorship parameters: `-f 2 -e 2 --auto-ttl --reverse-frag`.
- **Windows Service Automation**:
  - Registers `steamfix` as a native Windows service with `Automatic` startup.
  - Automatic service recovery policy on unexpected termination.
- **Reliability & State Management**:
  - Full backup of adapter DNS and DoH configuration to `$env:ProgramData\SteamFix`.
  - Graceful WinDivert file-lock handling and cleanup during reinstallation.
  - Safe elevation mechanism and non-destructive rollback upon failure.
- **One-Command Launcher**:
  - Single-line PowerShell launcher supporting in-memory invocation and process-isolated execution bypass.
