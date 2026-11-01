# ⚡ SteamFix

<div align="center">

**Một sản phẩm tiện ích mạng hỗ trợ game thủ phát triển bởi [ZeroMem Studio](https://zeromem.indevs.in/)**

[![Website](https://img.shields.io/badge/Official_Site-zeromem.indevs.in-6366f1?style=for-the-badge&logo=googlechrome&logoColor=white)](https://zeromem.indevs.in/)
[![GitHub Release](https://img.shields.io/github/v/release/ZeroMemInc/steam-fix?style=for-the-badge&color=22c55e&label=Release)](https://github.com/ZeroMemInc/steam-fix/releases)
[![Discord Support](https://img.shields.io/badge/Support-Discord_24%2F7-5865F2?style=for-the-badge&logo=discord&logoColor=white)](https://zeromem.indevs.in/)

</div>

---

**SteamFix** là công cụ tiện ích mạng nguồn mở dành cho Windows do **ZeroMem Studio** phát triển, giúp người dùng giải quyết nhanh các vấn đề mạng phổ biến như:
* Không thể mở được **Steam Store** (Cửa hàng Steam), màn hình đen hoặc báo lỗi kết nối `-105`.
* **Steam Community** (Chợ cộng đồng, kho đồ Inventory, Workshop) không hiển thị dữ liệu.
* **Ảnh đại diện (Avatar) bị lỗi**: Trong CS2 hoặc trong danh sách bạn bè Steam chỉ hiện ô vuông xám/dấu hỏi chấm.
* **Tải game bị đứng**: Tốc độ tải game bị tuột về 0 bytes/s hoặc báo lỗi `Content servers unreachable`.
* Một số game/launcher (như PUBG) bị treo cứng ở màn hình Loading kết nối ban đầu do máy chủ xác thực CDN bị gián đoạn.

---

## 🚀 HƯỚNG DẪN CÀI ĐẶT

### Bước 1: Sao chép (Copy) dòng lệnh này
Bôi đen toàn bộ dòng lệnh bên dưới rồi bấm **`Ctrl + C`** (hoặc nhấp chuột phải chọn **Sao chép**):

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "irm 'https://raw.githubusercontent.com/ZeroMemInc/steam-fix/main/SteamFix.ps1' | iex"
```

---

### Bước 2: Mở cửa sổ dòng lệnh trên Windows
Có 2 cách rất dễ làm, bạn chọn **Cách 1** là nhanh nhất:

#### Cách 1 (Nhanh nhất - khuyên dùng):
1. Nhìn trên bàn phím, bấm cùng lúc 2 phím: **`Phím Windows`** *(phím có biểu tượng cửa sổ cạnh nút Alt)* + **`Phím R`**.
2. Một ô cửa sổ nhỏ có tên **Run** hiện lên ở góc màn hình.
3. Nhập vào ô đó chữ: **`powershell`**
4. Bấm phím **Enter** trên bàn phím.

#### Cách 2 (Nếu dùng chuột):
1. Bấm vào nút **Start** (biểu tượng Windows ở góc dưới thanh taskbar máy tính).
2. Gõ chữ: **`powershell`**
3. Thấy biểu tượng **Windows PowerShell** hiện ra ➔ Nhấp chuột phải chọn **Run as administrator** (Chạy với quyền quản trị viên).

---

### Bước 3: Dán lệnh và bấm Cài đặt
1. Tại cửa sổ màu xanh hoặc đen vừa mở lên:
   - Nhấp **chuột phải** 1 lần vào giữa màn hình (hoặc bấm tổ hợp phím **`Ctrl + V`**) để dán dòng lệnh đã copy ở Bước 1 vào.
2. Bấm phím **Enter**.
3. Nếu màn hình Windows hiện bảng hỏi **User Account Control (UAC)** yêu cầu cấp quyền ➔ Bạn bấm chọn **Yes**.
4. Menu của SteamFix sẽ xuất hiện:
   ```text
   ============================================
             SteamFix by ZeroMem Studio
             https://zeromem.indevs.in/
   ============================================

   1. Install
   2. Uninstall
   3. Check status
   4. Refresh network
   0. Exit

   Select an option:
   ```
5. Bạn chỉ cần gõ số **`1`** rồi bấm **Enter**.
6. Chờ khoảng 3-5 giây cho công cụ tự động thiết lập xong. Sau đó khởi động lại Steam hoặc Game là bạn có thể chơi bình thường!

---

## 🛠️ CÁCH SỬ DỤNG CÁC TÍNH NĂNG KHÁC TRONG MENU

Mỗi khi bạn chạy lại dòng lệnh trên, công cụ sẽ mở ra một Menu điều khiển với các số từ `0` đến `4`:

* **Phím `1` - Install (Cài đặt)**: Tự động sao lưu mạng gốc ➔ Thiết lập DNS an toàn ➔ Cài dịch vụ nền tự chạy cùng Windows. (Chỉ cần cài 1 lần đầu).
* **Phím `2` - Uninstall (Gỡ cài đặt hoàn toàn)**: Nếu bạn không muốn dùng nữa, bấm số `2`, công cụ sẽ xóa sạch dịch vụ và khôi phục 100% cài đặt mạng về y hệt trạng thái ban đầu của máy bạn.
* **Phím `3` - Check status (Kiểm tra trạng thái)**: Kiểm tra xem công cụ đang chạy bình thường hay đã dừng.
* **Phím `4` - Refresh network (Làm mới mạng)**: Nếu vừa đổi Wi-Fi hoặc mạng bị giật lag, bấm số `4` để công cụ xóa sạch bộ nhớ đệm mạng (DNS Flush) và khởi động lại dịch vụ.
* **Phím `0` - Exit (Thoát)**: Đóng cửa sổ menu.

---

## 🔒 AN TOÀN & BẢO MẬT

* **Mã nguồn mở 100%**: Ai cũng có thể xem toàn bộ từng dòng mã lệnh tại repository này.
* **Không thu thập dữ liệu (Zero Telemetry)**: Công cụ không gửi bất kỳ thông tin cá nhân, tài khoản hay dữ liệu máy tính của bạn đi đâu cả.
* **Không chỉnh sửa phần mềm của bên thứ ba**: Không can thiệp, không vá, không sửa đổi file của Steam hay trò chơi.
* **Cơ chế sao lưu an toàn**: Tự động lưu cấu hình mạng cũ vào máy của bạn trước khi thay đổi, đảm bảo hoàn tác nguyên vẹn khi gỡ bỏ.

---

## 🌐 HỖ TRỢ & LIÊN HỆ

* **Trang chủ Studio**: [https://zeromem.indevs.in/](https://zeromem.indevs.in/)
* **Kênh hỗ trợ kỹ thuật 24/7**: Mở ticket hỗ trợ nhanh thông qua Discord trên trang chủ.
* **Báo cáo lỗi (Bug Reports)**: Gửi thông tin thông qua mục Issues của GitHub.

---

<div align="center">
  <sub>© 2026 ZeroMem Studio. All rights reserved. Enhancing your digital gaming experience.</sub>
</div>
