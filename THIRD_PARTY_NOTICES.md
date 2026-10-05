# Third-Party Notices

SteamFix utilizes open-source third-party software components to handle packet processing and DPI circumvention. These components remain the intellectual property of their respective authors and are licensed under their respective terms.

---

## 1. GoodbyeDPI

- **Project**: GoodbyeDPI
- **Author**: ValdikSS
- **Source Code**: [https://github.com/ValdikSS/GoodbyeDPI](https://github.com/ValdikSS/GoodbyeDPI)
- **License**: Apache License 2.0

### Apache License 2.0 Terms

```text
Copyright 2017-2024 ValdikSS

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```

---

## 2. WinDivert (Windows Packet Divert)

GoodbyeDPI relies on the WinDivert kernel driver and user-mode library to capture and modify network packets.

- **Project**: WinDivert
- **Author**: basil00
- **Source Code**: [https://github.com/basil00/Divert](https://github.com/basil00/Divert)
- **License**: GNU Lesser General Public License version 3 (LGPLv3) / GNU General Public License version 2 (GPLv2)

### Summary

WinDivert is distributed in binary form bundled alongside official GoodbyeDPI releases. The WinDivert driver (`WinDivert64.sys`) and library (`WinDivert.dll`) are licensed under LGPLv3/GPLv2.

---

## Disclaimer

SteamFix does not claim ownership of GoodbyeDPI, WinDivert, or any upstream libraries. SteamFix automates service orchestration and DNS-over-HTTPS configuration for seamless end-user operation on Windows.
