# SteamFix

SteamFix là công cụ tiện ích mạng nguồn mở dành cho Windows, được thiết kế nhằm hỗ trợ chẩn đoán và khắc phục tình trạng gián đoạn kết nối khi truy cập dịch vụ Steam, các trình khởi chạy trò chơi và website do hiện tượng DNS bị lỗi phân giải hoặc lọc gói tin mạng TLS/SNI. Tiện ích kết hợp cấu hình DNS bảo mật (DNS-over-HTTPS) và công cụ GoodbyeDPI để giúp khôi phục khả năng truy cập Steam Store, Steam Community, tải ảnh đại diện (avatar), kết nối máy chủ CDN và tải tài nguyên một cách ổn định, minh bạch.

Dự án cam kết tuân thủ đầy đủ **Tiêu chuẩn Cộng đồng của GitHub (GitHub Community Guidelines)** và **Chính sách Sử dụng Chấp nhận được (Acceptable Use Policies)**: mã nguồn mở 100%, không thu thập dữ liệu, không can thiệp vào tiến trình trò chơi hay hệ thống chống gian lận, và có cơ chế khôi phục cài đặt mạng ban đầu an toàn.

---

## ⚡ Hướng Dẫn Cài Đặt Nhanh

Bạn có thể chạy công cụ trực tiếp thông qua cửa sổ dòng lệnh trên Windows:

### Cách 1: Mở qua Hộp thoại Run (Nhanh nhất)

1. Nhấn tổ hợp phím **`Windows + R`** trên bàn phím để mở hộp thoại **Run**.
2. Nhập vào ô tìm kiếm:
   ```text
   powershell
   ```
   Sau đó nhấn **Enter** (hoặc nhấn `Ctrl + Shift + Enter` để mở với quyền Administrator).
3. Sao chép (Copy) toàn bộ lệnh dưới đây:

   ```powershell
   powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "irm 'https://raw.githubusercontent.com/OzymoGitAlt/steam-fix/main/SteamFix.ps1' | iex"
   ```

4. Chuyển sang cửa sổ dòng lệnh vừa mở:
   - Nhấp **chuột phải** vào màn hình để dán lệnh (hoặc nhấn tổ hợp phím **`Ctrl + V`**).
5. Nhấn phím **Enter**.
6. Nếu Windows hiện thông báo yêu cầu cấp quyền quản trị (**UAC - User Account Control**), chọn **Yes** để tiếp tục.
7. Khi menu SteamFix xuất hiện trên màn hình, nhấn phím **`1`** rồi nhấn **Enter** để tiến hành thiết lập.

---

### Cách 2: Mở qua Menu Start / Tìm kiếm Windows

1. Nhấn phím **`Windows`** trên bàn phím (hoặc bấm vào biểu tượng Start ở góc màn hình).
2. Gõ từ khóa: **`PowerShell`** (hoặc **`Command Prompt`** / **`cmd`**).
3. Nhấp chuột phải vào kết quả hiện ra và chọn **Run as administrator** (Chạy với quyền quản trị viên).
4. Dán dòng lệnh sau vào cửa sổ:

   ```powershell
   powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "irm 'https://raw.githubusercontent.com/OzymoGitAlt/steam-fix/main/SteamFix.ps1' | iex"
   ```

5. Nhấn phím **Enter**.
6. Chọn số **`1`** và nhấn **Enter** để hoàn tất cài đặt.

> [!NOTE]
> Tham số `-ExecutionPolicy Bypass` chỉ áp dụng tạm thời cho đúng phiên PowerShell đang thực thi, hoàn toàn không làm thay đổi hay suy giảm chính sách bảo mật hệ thống lâu dài của Windows.

---

## 🔍 Kiểm Tra Mã Nguồn Trước Khi Chạy (Khuyến nghị bảo mật)

Để đảm bảo tính minh bạch theo tiêu chuẩn an toàn phần mềm, bạn hoàn toàn có thể tải về và kiểm tra toàn bộ mã nguồn trước khi cấp quyền thực thi:

1. Tải tệp script về máy:
   ```powershell
   Invoke-WebRequest 'https://raw.githubusercontent.com/OzymoGitAlt/steam-fix/main/SteamFix.ps1' -OutFile SteamFix.ps1
   ```
2. Mở file bằng Notepad hoặc trình soạn thảo mã nguồn để đọc:
   ```powershell
   notepad SteamFix.ps1
   ```
3. Khởi chạy tệp cục bộ sau khi đã xem xét:
   ```powershell
   powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\SteamFix.ps1
   ```

---

## Cam Kết Tuân Thủ Tiêu Chuẩn Cộng Đồng GitHub & An Toàn

Dự án SteamFix tuân thủ nghiêm ngặt các tiêu chuẩn đạo đức và bảo mật mã nguồn mở:

- **Không can thiệp vào phần mềm của bên thứ ba**: Không chỉnh sửa, không vá (patch), không dịch ngược hay can thiệp vào bất kỳ tệp thực thi nào của Steam (`Steam.exe`) hoặc các tệp tin trò chơi.
- **Không can thiệp vào bộ nhớ hay tiến trình (No Injection)**: Không sử dụng DLL Injection, hook API, hay can thiệp vào bộ nhớ của tiến trình game.
- **Không vượt cơ chế chống gian lận (Anti-Cheat Friendly)**: Không tương tác với các dịch vụ bảo mật game như Valve Anti-Cheat (VAC), BattlEye, Easy Anti-Cheat hay Riot Vanguard. Hoạt động độc lập ở tầng kết nối mạng hệ thống.
- **Không thu thập dữ liệu (Zero Telemetry)**: Không có mã phân tích người dùng, không theo dõi hành vi, không lưu trữ thông tin đăng nhập hay tài khoản.
- **Không tạo lỗ hổng bảo mật**: Không vô hiệu hóa Windows Defender, không tắt tường lửa (Firewall), không can thiệp cài đặt chứng chỉ bảo mật giả mạo (Root CA).
- **Tính toàn vẹn tệp nhị phân**: Bản phát hành GoodbyeDPI đi kèm được tải trực tiếp từ nguồn chính thức của tác giả ValdikSS và được kiểm tra mã băm SHA-256 nghiêm ngặt trước khi giải nén.

---

## Tính Năng Chính

- **DNS-over-HTTPS (DoH) bảo mật**: Sử dụng máy chủ DNS công cộng của Google (`8.8.8.8` / `8.8.4.4`) được mã hóa qua giao thức HTTPS nhằm ngăn chặn việc phân giải sai địa chỉ IP. Tự động chuyển đổi tương thích nếu phiên bản Windows cũ không hỗ trợ DoH native.
- **Xử lý phân mảnh gói tin TLS (DPI Bypass)**: Vận hành GoodbyeDPI với các tham số chuẩn (`-f 2 -e 2 --auto-ttl --reverse-frag`) giúp phân tách phần tiêu đề SNI trong gói tin Client Hello mà không làm ảnh hưởng đến dữ liệu truyền tải.
- **Vận hành dưới dạng Windows Service**: Tạo dịch vụ hệ thống `steamfix` tự động khởi chạy và phục hồi khi máy tính khởi động.
- **Menu điều khiển trực quan**: Giao diện điều khiển tương tác rõ ràng (Cài đặt, Gỡ cài đặt, Trạng thái, Làm mới bộ đệm mạng).
- **Sao lưu và khôi phục mạng an toàn**: Tự động lưu cấu hình mạng ban đầu của người dùng vào tệp tin JSON và khôi phục nguyên trạng 100% khi người dùng chọn Gỡ cài đặt.

---

## Các Trường Hợp Hỗ Trợ Phù Hợp

SteamFix chỉ giải quyết các vấn đề xuất phát từ tầng kết nối mạng:

- **Steam Store không vào được**: Báo lỗi kết nối `Error -105` hoặc tải trang chậm do truy vấn tên miền bị ngắt quãng.
- **Steam Community không load**: Chợ cộng đồng (Market), kho đồ (Inventory), hồ sơ cá nhân và Steam Workshop bị nghẽn mạng.
- **Steam avatar không hiện**: Ảnh đại diện của tài khoản cá nhân và danh sách bạn bè hiển thị ô vuông mặc định do CDN hình ảnh bị gián đoạn.
- **CS2 không load avatar**: Trong Counter-Strike 2, bảng điểm hiển thị avatar mặc định thay vì avatar thật do kết nối tải ảnh từ CDN Steam bị chặn.
- **Tải game bị đứng tốc độ**: Tốc độ tải nội dung game trên Steam bị tuột về 0 bytes/s hoặc báo lỗi `Content servers unreachable`.
- **PUBG hoặc game launcher bị kẹt kết nối**: Trò chơi bị treo ở màn hình loading/connecting ban đầu do máy chủ API/CDN xác thực bị ngắt kết nối mạng.

> [!IMPORTANT]
> **Giới hạn kỹ thuật**: SteamFix **không thể** và **không tuyên bố** khắc phục các lỗi về phần cứng máy tính, lỗi vi xử lý đồ họa (GPU), lỗi dựng hình (graphics bugs) trong game, tệp game bị hỏng, lỗi máy chủ nhà phát hành bảo trì, hoặc các hình phạt hạn chế tài khoản.

---

## Menu Điều Khiển

Khi khởi chạy `SteamFix.ps1`, giao diện quản lý cung cấp các tính năng:

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

- **`1. Install` (Cài đặt)**: Tự động sao lưu cài đặt DNS -> Thiết lập DNS bảo mật -> Kiểm tra mã băm SHA-256 của GoodbyeDPI -> Khởi tạo dịch vụ Windows Service `steamfix`.
- **`2. Uninstall` (Gỡ bỏ)**: Dừng và xóa dịch vụ `steamfix`, hoàn trả cấu hình mạng và DNS về đúng trạng thái ban đầu của hệ thống, dọn sạch thư mục cài đặt.
- **`3. Check status` (Kiểm tra trạng thái)**: Kiểm tra trạng thái hoạt động thực tế của dịch vụ `steamfix` trong Windows Service Manager.
- **`4. Refresh network` (Làm mới mạng)**: Khởi động lại dịch vụ `steamfix`, giải phóng và làm sạch bộ nhớ đệm DNS (`ipconfig /flushdns`), xóa bộ đệm ARP và đăng ký lại DNS (`ipconfig /registerdns`).
- **`0. Exit` (Thoát)**: Đóng giao diện công cụ.

---

## Hoạt Động Của Dịch Vụ Mạng (Phạm Vi Toàn Hệ Thống)

Dịch vụ GoodbyeDPI được thiết lập để xử lý gói tin mạng ở cấp hệ thống:
- **Tác động tích cực**: Tự động cải thiện kết nối cho cả trình duyệt web (Chrome, Edge, Firefox) và các trình khởi chạy khác mà không cần cài đặt proxy thủ công.
- **Khuyến cáo khi dùng cùng VPN**: Khi sử dụng phần mềm VPN toàn phần (Full-tunnel VPN), cả hai phần mềm có thể xung đột do cùng điều hướng bộ lọc gói tin qua driver WinDivert. Nếu cần sử dụng VPN, người dùng nên chọn Gỡ cài đặt (`Option 2`) trước.

---

## Quy Tắc Ứng Xử & Đóng Góp

Dự án coi trọng việc xây dựng một cộng đồng lành mạnh, tôn trọng lẫn nhau và cởi mở:
- Vui lòng xem [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) để biết thêm về Quy tắc Ứng xử Cộng đồng.
- Vui lòng xem [CONTRIBUTING.md](CONTRIBUTING.md) nếu bạn muốn gửi ý kiến đóng góp hoặc Pull Request.
- Vui lòng xem [SECURITY.md](SECURITY.md) về Chính sách An toàn Thông tin và cách báo cáo lỗ hổng.

---

## Giấy Phép & Nguồn Gốc Thành Phần

- Dự án SteamFix được phát hành theo giấy phép nguồn mở **MIT License**.
- Các thành phần nguồn mở của bên thứ ba được sử dụng hợp pháp và giữ nguyên bản quyền của tác giả:
  - **GoodbyeDPI** bởi tác giả ValdikSS (Giấy phép Apache License 2.0).
  - Driver **WinDivert** bởi tác giả basil00 (Giấy phép LGPLv3 / GPLv2).
  - Chi tiết thông cáo bản quyền xem tại [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md).

---

## Tuyên Bố Miễn Trừ Trách Nhiệm

SteamFix là một dự án nghiên cứu và tiện ích mã nguồn mở độc lập, phi lợi nhuận. Steam, Counter-Strike 2, PUBG và Valve là các thương hiệu đã được đăng ký của các chủ sở hữu tương ứng. SteamFix hoàn toàn không có mối liên kết, tài trợ hay bảo trợ bởi các tổ chức hoặc nhà phát hành nêu trên.
