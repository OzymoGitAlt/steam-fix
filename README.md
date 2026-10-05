# SteamFix

SteamFix là công cụ tiện ích mạng nguồn mở dành cho Windows, được thiết kế nhằm khắc phục tình trạng gián đoạn kết nối khi truy cập Steam, các launcher trò chơi và website do hiện tượng DNS bị can thiệp, lọc tên miền hoặc kiểm duyệt gói tin DPI/SNI. Tiện ích kết hợp công nghệ DNS mã hóa (DNS-over-HTTPS) và công cụ GoodbyeDPI để giúp khôi phục khả năng truy cập Steam Store, Steam Community, tải ảnh đại diện (avatar), kết nối máy chủ CDN và tải game một cách ổn định.

---

## ⚡ Hướng Dẫn Cài Đặt Nhanh Bằng Một Dòng Lệnh (Quan Trọng Nhất)

Bạn chỉ cần mở cửa sổ dòng lệnh trên Windows, dán duy nhất một câu lệnh và nhấn Enter. Chi tiết từng bước bên dưới:

### Cách 1: Mở qua Hộp thoại Run (Nhanh và đơn giản nhất)

1. Nhấn tổ hợp phím **`Windows + R`** trên bàn phím để mở hộp thoại **Run**.
2. Nhập vào ô tìm kiếm:
   ```text
   powershell
   ```
   *(Hoặc gõ `cmd` đều được)*, sau đó nhấn **Enter** (hoặc nhấn tổ hợp phím `Ctrl + Shift + Enter` để chạy với quyền Administrator).
3. Sao chép (Copy) toàn bộ lệnh dưới đây:

   ```powershell
   powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "irm 'https://raw.githubusercontent.com/OzymoGit/SteamFix/main/SteamFix.ps1' | iex"
   ```

4. Chuyển sang cửa sổ dòng lệnh vừa mở:
   - Nhấp **chuột phải** vào màn hình đen để dán lệnh (hoặc nhấn tổ hợp phím **`Ctrl + V`**).
5. Nhấn phím **Enter** trên bàn phím.
6. Nếu Windows hiện thông báo yêu cầu cấp quyền quản trị (**UAC - User Account Control**), bạn chọn **Yes** để tiếp tục.
7. Khi menu SteamFix xuất hiện trên màn hình, bạn nhấn số **`1`** rồi nhấn **Enter** để tiến hành cài đặt.

---

### Cách 2: Mở qua Menu Start / Tìm kiếm Windows

1. Nhấn phím **`Windows`** trên bàn phím (hoặc bấm vào biểu tượng Start ở góc dưới màn hình).
2. Gõ từ khóa: **`PowerShell`** (hoặc **`cmd`** / **`Command Prompt`**).
3. Nhấp chuột phải vào kết quả hiện ra và chọn **Run as administrator** (Chạy với quyền quản trị viên).
4. Dán dòng lệnh sau vào cửa sổ:

   ```powershell
   powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "irm 'https://raw.githubusercontent.com/OzymoGit/SteamFix/main/SteamFix.ps1' | iex"
   ```

5. Nhấn phím **Enter**.
6. Chọn số **`1`** và nhấn **Enter** để hoàn tất cài đặt.

> [!NOTE]
> Tham số `-ExecutionPolicy Bypass` chỉ áp dụng tạm thời cho đúng tiến trình chạy lệnh đó, hoàn toàn không làm thay đổi hay ảnh hưởng đến chính sách bảo mật hệ thống máy tính của bạn.

---

## 🔍 Cách Kiểm Tra Script Trước Khi Cài Đặt (Dành cho ai muốn xem code trước)

Nếu bạn muốn tải về máy và tự xem nội dung mã nguồn trước khi cấp quyền:

1. Mở PowerShell hoặc CMD và chạy lệnh sau để tải file về máy:
   ```powershell
   Invoke-WebRequest 'https://raw.githubusercontent.com/OzymoGit/SteamFix/main/SteamFix.ps1' -OutFile SteamFix.ps1
   ```
2. Mở file lên bằng Notepad để kiểm tra:
   ```powershell
   notepad SteamFix.ps1
   ```
3. Sau khi kiểm tra xong, khởi chạy script bằng lệnh:
   ```powershell
   powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\SteamFix.ps1
   ```

---

## SteamFix Là Gì?

SteamFix giúp người dùng Windows khắc phục tình trạng không vào được Steam Store hoặc Steam Community khi đường truyền mạng can thiệp vào phân giải DNS hoặc lọc gói tin TLS/SNI. Bằng cách thiết lập cấu hình **DNS-over-HTTPS (DoH)** nguyên bản của Windows kết hợp với dịch vụ nền **GoodbyeDPI** chạy tự động (`steamfix`), SteamFix giải quyết vấn đề từ tầng mạng mà không cần sử dụng phần mềm VPN, không cần mua proxy và không cần tạo bất kỳ tài khoản trung gian nào.

SteamFix hoạt động hoàn toàn ở tầng truyền dẫn gói tin:
- **Không chỉnh sửa bất kỳ file nào của Steam** (Các file `Steam.exe`, thư mục cài game đều được giữ nguyên 100%).
- **Không can thiệp vào bộ nhớ hay tiến trình game** (Không tiêm DLL, không hook game).
- **Không can thiệp vào các hệ thống chống gian lận** (Hoàn toàn an toàn và tương thích với VAC, BattlEye, Easy Anti-Cheat).
- **Không thu thập dữ liệu (No Telemetry)**: Hoàn toàn riêng tư, không gửi dữ liệu ra bên ngoài.

---

## Tính Năng Chính

- **Tự động cấu hình DNS-over-HTTPS (DoH)**: Sử dụng máy chủ DNS bảo mật của Google (`8.8.8.8` / `8.8.4.4`) mã hóa qua HTTPS để chống việc DNS bị trả sai địa chỉ IP.
- **Vượt chặn kiểm duyệt gói tin sâu (DPI)**: Tích hợp công cụ GoodbyeDPI với bộ tham số tối ưu (`-f 2 -e 2 --auto-ttl --reverse-frag`) nhằm phân mảnh tiêu đề TLS Client Hello SNI.
- **Chạy ngầm dưới dạng Windows Service**: Hoạt động tự động như một dịch vụ hệ thống (`steamfix`), tự khởi động cùng Windows và có cơ chế tự phục hồi nếu gặp sự cố.
- **Menu điều khiển trực quan**: Giao diện dòng lệnh dễ sử dụng với các tùy chọn Cài đặt, Gỡ cài đặt, Kiểm tra trạng thái và Làm mới mạng.
- **Tự động sao lưu cài đặt mạng**: Lưu lại thông tin DNS cũ trước khi thay đổi, đảm bảo khôi phục nguyên trạng 100% khi bạn chọn Gỡ cài đặt.
- **Xử lý khóa file WinDivert**: Tự động giải phóng tiến trình cũ và xử lý việc khóa file driver một cách an toàn.

---

## Các Vấn Đề Thường Gặp Mà SteamFix Có Thể Khắc Phục

SteamFix được tối ưu cho các lỗi phát sinh do đường truyền mạng hoặc lọc gói tin:

- **Steam Store không vào được**: Cửa hàng Steam báo lỗi kết nối `Error -105` hoặc hiển thị màn hình đen.
- **Steam Community không load**: Chợ cộng đồng (Market), kho đồ (Inventory), hồ sơ cá nhân và Steam Workshop không thể tải dữ liệu.
- **Steam avatar không hiện**: Ảnh đại diện của tài khoản cá nhân và danh sách bạn bè hiển thị ô vuông màu xám.
- **CS2 không load avatar**: Trong Counter-Strike 2, bảng điểm và người chơi hiển thị avatar mặc định thay vì avatar thật do máy chủ CDN hình ảnh bị chặn.
- **Game không tải được avatar Steam**: Các game kết nối qua Steamworks API không lấy được dữ liệu ảnh đại diện người chơi.
- **Steam tải game bị lỗi**: Tốc độ tải game bị tuột về 0 bytes/s hoặc báo lỗi `Content servers unreachable`.
- **Steam CDN bị chặn**: Không thể tải dữ liệu hình ảnh, file cập nhật và tài nguyên trò chơi từ hệ thống máy chủ nội dung của Steam.
- **PUBG treo ở bước kết nối do mạng**: Game PUBG bị kẹt ở màn hình loading ban đầu hoặc báo lỗi kết nối sảnh chờ khi các địa chỉ máy chủ CDN/API bị chặn bởi đường truyền mạng.
- **Trang web bị chặn do DNS hoặc DPI**: Các trang web thông thường bị chặn khi truy cập qua trình duyệt web.

> [!IMPORTANT]
> **Phạm vi xử lý**: SteamFix chỉ xử lý các lỗi bắt nguồn từ tầng kết nối mạng. SteamFix **không thể** khắc phục các lỗi phần cứng, lỗi card đồ họa GPU, lỗi hiển thị hình ảnh trong game (ví dụ: lỗi khói trong PUBG), file game bị hỏng, lỗi hệ thống chống gian lận hoặc khi máy chủ của game đang bảo trì.

---

## Giải Thích Về Hiện Tượng Chặn Mạng

Hiện tượng gián đoạn kết nối internet tới các dịch vụ game thường xảy ra ở hai tầng kỹ thuật:

1. **Can thiệp DNS (DNS Poisoning)**:
   - Khi máy tính gửi yêu cầu hỏi địa chỉ IP của các tên miền như `store.steampowered.com`, máy chủ DNS mặc định của mạng internet trả về địa chỉ IP không đúng hoặc địa chỉ chặn.
   - *Cách xử lý*: SteamFix bật **DNS-over-HTTPS (DoH)**, toàn bộ yêu cầu DNS được mã hóa qua kết nối HTTPS an toàn, ngăn chặn việc can thiệp địa chỉ IP.

2. **Lọc gói tin sâu qua tên miền (DPI / SNI Filtering)**:
   - Dù đã phân giải đúng địa chỉ IP, nhưng trong bước bắt tay TLS ban đầu (gói tin Client Hello), tên miền bạn muốn truy cập (SNI) vẫn được gửi dưới dạng văn bản rõ. Thiết bị kiểm duyệt mạng phát hiện tên miền này và gửi lệnh ngắt kết nối (TCP RST).
   - *Cách xử lý*: SteamFix sử dụng GoodbyeDPI để tách nhỏ và đảo mảnh gói tin Client Hello (`-f 2 -e 2 --auto-ttl --reverse-frag`). Do tên miền bị chia nhỏ qua các phân đoạn mạng, thiết bị lọc gói tin không nhận diện được và cho phép kết nối đi qua bình thường.

---

## Chi Tiết Menu Điều Khiển

Khi khởi chạy `SteamFix.ps1`, bạn sẽ thấy giao diện menu:

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

- **`1. Install` (Cài đặt)**: Tự động sao lưu DNS hiện tại -> Thiết lập Google DoH -> Tải và kiểm tra tính toàn vẹn của GoodbyeDPI -> Khởi tạo Windows Service chạy ngầm.
- **`2. Uninstall` (Gỡ cài đặt)**: Dừng và xóa service `steamfix`, khôi phục lại toàn bộ cài đặt DNS ban đầu của máy tính, xóa sạch file cài đặt.
- **`3. Check status` (Kiểm tra trạng thái)**: Xem dịch vụ `steamfix` đang chạy (Running) hay đã dừng, kiểm tra chế độ khởi động và đường dẫn file thực thi.
- **`4. Refresh network` (Làm mới mạng)**: Khởi động lại dịch vụ `steamfix`, xóa bộ nhớ đệm DNS (`ipconfig /flushdns`), xóa bộ đệm ARP và đăng ký lại DNS (`ipconfig /registerdns`).
- **`0. Exit` (Thoát)**: Đóng giao diện menu.

---

## GoodbyeDPI Hoạt Động Trên Toàn Hệ Thống (Global)

SteamFix thiết lập GoodbyeDPI chạy dưới dạng dịch vụ ngầm cho toàn bộ máy tính:

- **Lợi ích**: Không chỉ riêng ứng dụng Steam, mà các trình duyệt web (Chrome, Edge, Firefox) và các trình khởi chạy game khác cũng sẽ tự động được hỗ trợ vượt lọc gói tin DPI mà không cần cài đặt thêm tiện ích mở rộng.
- **Lưu ý khi dùng VPN**: Nếu bạn đang sử dụng phần mềm VPN toàn phần, hai công cụ có thể xung đột do cùng xử lý gói tin mạng. Bạn nên chọn Gỡ cài đặt (`Option 2`) trong SteamFix trước khi bật VPN.

---

## Câu Hỏi Thường Gặp (FAQ)

#### SteamFix có phải là phần mềm VPN không?
Không. SteamFix không định tuyến dữ liệu của bạn qua máy chủ trung gian nào. Kết nối đi thẳng từ máy tính của bạn tới máy chủ của Steam và website với tốc độ mạng và ping gốc.

#### SteamFix có chỉnh sửa file của Steam hay game không?
Hoàn toàn không. Công cụ không chỉnh sửa hay thay đổi bất kỳ file thực thi hay file dữ liệu nào của Steam và game.

#### Dùng SteamFix có bị cấm chơi (ban) không?
Không. Tiện ích chỉ xử lý gói tin mạng bên ngoài hệ điều hành, không can thiệp vào bộ nhớ game và không đụng chạm đến phần mềm chống gian lận (Anti-Cheat).

#### Khi gỡ cài đặt có bị mất cấu hình mạng cũ không?
Không. SteamFix tự động ghi lại bản sao lưu cấu hình DNS trước khi áp dụng thay đổi và sẽ trả lại chính xác cấu hình cũ khi bạn chọn Gỡ cài đặt (`Option 2`).

---

## Giấy Phép & Nguồn Gốc

- Dự án phát hành theo giấy phép nguồn mở **MIT License**.
- Tích hợp công cụ [GoodbyeDPI](https://github.com/ValdikSS/GoodbyeDPI) của tác giả ValdikSS và driver [WinDivert](https://github.com/basil00/Divert) của tác giả basil00. Chi tiết xem tại `THIRD_PARTY_NOTICES.md`.

---

## Tuyên Bố Miễn Trừ Trách Nhiệm

SteamFix được cung cấp miễn phí và "nguyên trạng". Steam, Counter-Strike 2, PUBG và Valve là nhãn hiệu thuộc sở hữu của các tổ chức tương ứng. SteamFix là một tiện ích độc lập và không có bất kỳ mối liên hệ nào với các công ty trên.
