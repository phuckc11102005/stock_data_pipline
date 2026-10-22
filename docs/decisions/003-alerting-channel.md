# 📌 ADR-003: Kênh Cảnh Báo (Alerting Channel)

**Ngày:** 2026-10-22
**Trạng thái:** Đã chấp thuận

## Bối cảnh
Cần chọn kênh gửi cảnh báo tự động khi có tín hiệu giao dịch.

## Các lựa chọn

| Kênh | Ưu điểm | Nhược điểm |
|---|---|---|
| Telegram Bot | Miễn phí, thông báo tức thì, API đơn giản, phổ biến ở VN | Cần tạo bot riêng |
| Discord Webhook | Dễ setup, không cần tài khoản bot riêng | Ít phổ biến hơn Telegram ở VN |
| Email (SMTP) | Mọi người đều có email | Chậm, dễ vào spam, khó đọc trên di động |
| Slack | Professional, tích hợp tốt | Cần workspace, hết quota free |

## Quyết định
Dùng **Telegram Bot** làm kênh cảnh báo chính vì:
- Miễn phí, không giới hạn tin nhắn
- Thông báo push ngay lập tức trên điện thoại
- API đơn giản với thư viện `python-telegram-bot`
- Phổ biến trong cộng đồng trading Việt Nam

## Hệ quả
- Cần đăng ký Bot với @BotFather và lưu token an toàn trong `.env`
- Cần có `TELEGRAM_CHAT_ID` của nhóm/cá nhân nhận cảnh báo
