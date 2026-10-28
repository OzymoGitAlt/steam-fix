# Hướng Dẫn Đóng Góp (Contributing Guidelines)

Cảm ơn bạn đã quan tâm đến việc đóng góp cho **SteamFix**! Dự án luôn chào đón các đóng góp từ cộng đồng nhằm cải thiện tính ổn định, bảo mật và hiệu năng.

---

## 1. Nguyên Tắc Cốt Lõi

Khi đề xuất thay đổi hoặc mở Pull Request (PR), vui lòng tuân thủ nghiêm ngặt các nguyên tắc sau:

1. **Tuân thủ tiêu chuẩn cộng đồng GitHub & An toàn thông tin**:
   - Không chứa mã độc hại, backdoor, phần mềm quảng cáo hoặc theo dõi (telemetry).
   - Không chứa bất kỳ cơ chế nào nhằm can thiệp vào bộ nhớ game, tệp thực thi của Steam, hoặc vượt qua các hệ thống chống gian lận (Anti-Cheat).
   - Tuyệt đối không can thiệp hoặc thay đổi các chính sách bảo mật hệ thống vĩnh viễn (như tắt Windows Defender, tắt Firewall, sửa Root Certificate).

2. **Tính tối giản và minh bạch**:
   - Giữ mã nguồn PowerShell dễ đọc, có chú thích rõ ràng.
   - Luôn đảm bảo cơ chế sao lưu (backup) và khôi phục (rollback/uninstall) hoạt động an toàn trước và sau khi thay đổi thiết lập mạng của người dùng.

---

## 2. Quy Trình Đóng Góp

### Báo lỗi (Reporting Bugs)
- Trước khi tạo Issue mới, vui lòng kiểm tra danh sách Issues đã đóng hoặc mở xem lỗi đã được báo cáo chưa.
- Cung cấp thông tin chi tiết: phiên bản Windows, thông báo lỗi cụ thể (ảnh chụp màn hình hoặc log lỗi).

### Đề xuất tính năng (Feature Requests)
- Mở một Issue với nhãn `enhancement`, giải thích rõ vấn đề bạn muốn giải quyết và lý do tính năng này mang lại lợi ích cho người dùng.

### Gửi Pull Request (PR)
1. Fork repository về tài khoản GitHub của bạn.
2. Tạo một nhánh mới từ nhánh `main` (`git checkout -b feature/ten-tinh-nang`).
3. Thực hiện thay đổi, kiểm tra cú pháp script (`powershell -NoProfile -Command "..."`).
4. Commit thay đổi với thông điệp rõ ràng theo chuẩn Conventional Commits (ví dụ: `fix: ...`, `docs: ...`).
5. Push nhánh lên fork của bạn và mở Pull Request hướng về nhánh `main` của repository gốc.
