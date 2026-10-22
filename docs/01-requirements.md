# 📋 Yêu Cầu Dự Án (Requirements)

## 1. Yêu cầu chức năng (Functional Requirements)

### 1.1 Thu thập dữ liệu (Data Ingestion)
- [ ] Hệ thống phải tự động thu thập dữ liệu OHLCV (Open, High, Low, Close, Volume) theo lịch định kỳ
- [ ] Hỗ trợ danh sách mã cổ phiếu có thể cấu hình (VN30, US stocks, hoặc tuỳ chọn)
- [ ] Hỗ trợ nhiều khung thời gian: 1 phút, 5 phút, 1 ngày
- [ ] Lưu dữ liệu thô gốc trước khi xử lý (không mất mát dữ liệu gốc)
- [ ] Xử lý lỗi và tự thử lại khi API bị lỗi (retry logic)

### 1.2 Lưu trữ dữ liệu (Storage)
- [ ] Tổ chức lưu trữ theo mô hình Medallion: Bronze → Silver → Gold
- [ ] Bronze: Dữ liệu thô định dạng JSON/Parquet, phân vùng theo ngày
- [ ] Silver: Dữ liệu đã làm sạch, chuẩn hoá schema, chuyển đổi múi giờ về UTC+7
- [ ] Gold: Dữ liệu đã tính toán chỉ số kỹ thuật, sẵn sàng để phân tích

### 1.3 Xử lý & Phân tích (Processing & Analysis)
- [ ] Tính toán chỉ số kỹ thuật:
  - SMA 20, SMA 50, SMA 200
  - EMA 12, EMA 26
  - RSI 14
  - MACD (12, 26, 9)
  - Bollinger Bands (20, 2)
  - Volume SMA 20
- [ ] Phát hiện tín hiệu giao dịch (Signal Detection):
  - Golden Cross (MA ngắn cắt lên trên MA dài)
  - Death Cross (MA ngắn cắt xuống dưới MA dài)
  - RSI vùng quá mua (> 70) / quá bán (< 30)
  - Volume spike (khối lượng > 2x trung bình 20 phiên)
  - Breakout khỏi Bollinger Bands

### 1.4 Cảnh báo (Alerting)
- [ ] Gửi cảnh báo tự động qua **Telegram Bot** khi phát hiện tín hiệu
- [ ] Nội dung cảnh báo gồm: mã cổ phiếu, tên tín hiệu, giá hiện tại, thời gian, gợi ý hành động
- [ ] Có cơ chế chống spam: không gửi cùng 1 tín hiệu quá 1 lần/phiên
- [ ] Hỗ trợ chọn mức độ cảnh báo: HIGH / MEDIUM / LOW

### 1.5 Điều phối (Orchestration)
- [ ] Các pipeline chạy tự động theo lịch (cron) qua Apache Airflow
- [ ] Có thể kích hoạt chạy thủ công (manual trigger)
- [ ] Ghi log đầy đủ và thông báo khi pipeline thất bại

### 1.6 Trực quan hoá (Dashboard)
- [ ] Dashboard hiển thị biểu đồ nến (candlestick) kèm chỉ số kỹ thuật
- [ ] Bảng danh sách cảnh báo gần đây
- [ ] So sánh hiệu suất nhiều mã cổ phiếu

---

## 2. Yêu cầu phi chức năng (Non-Functional Requirements)

| Tiêu chí | Mục tiêu MVP |
|---|---|
| **Latency (Batch)** | Hoàn thành xử lý 1 mã cổ phiếu trong < 30 giây |
| **Độ tin cậy** | Pipeline retry tối thiểu 3 lần khi lỗi API |
| **Khả năng mở rộng** | Hỗ trợ ít nhất 50 mã theo dõi đồng thời |
| **Lưu trữ** | Giữ dữ liệu thô tối thiểu 2 năm |
| **Quan sát được** | Có log đầy đủ cho mọi bước trong pipeline |

---

## 3. Các trường hợp nằm ngoài phạm vi MVP (Out of Scope)

- Streaming real-time dưới 1 phút (sẽ làm Phase 2)
- Phân tích sentiment từ tin tức / mạng xã hội
- Backtesting chiến lược giao dịch tự động
- Kết nối trực tiếp với sàn để đặt lệnh mua/bán
- Xác thực người dùng / Multi-tenant
