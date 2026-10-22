# 🗓️ Lộ Trình Sprint & Backlog (Sprint Roadmap)

## Tổng quan 4 Sprint (4 tuần MVP)

```
Sprint 1       Sprint 2       Sprint 3       Sprint 4
(Tuần 1)       (Tuần 2)       (Tuần 3)       (Tuần 4)
────────────   ────────────   ────────────   ────────────
Hạ tầng &     Fetch + Lưu   Xử lý +        Dashboard +
Môi trường    Bronze/Silver  Indicators +   Alerting +
Docker/        thật          Signals        Hoàn thiện
Airflow
```

---

## 🏁 Sprint 1 — Hạ tầng & Môi trường (Tuần 1)

**Mục tiêu:** Toàn bộ thành viên có thể chạy `docker compose up` và thấy tất cả service hoạt động.

| Task ID | Mô tả | Role | Ưu tiên |
|---|---|---|---|
| OPS-01 | Viết `docker-compose.yml` (MinIO, Postgres, Airflow) | R4 | 🔴 CRITICAL |
| OPS-02 | Viết Dockerfile cho Python service | R4 | 🔴 CRITICAL |
| OPS-03 | Viết `.env.example` | R4 | 🔴 CRITICAL |
| OPS-04 | Script khởi tạo MinIO buckets & PostgreSQL schema | R4 | 🟡 HIGH |
| OPS-05 | Tài liệu SETUP.md | R4 | 🟡 HIGH |
| ING-01 | Cài đặt và kiểm tra thư viện: yfinance, vnstock | R1 | 🟡 HIGH |
| ING-02 | Viết `config/symbols.yaml` với 5 mã thử nghiệm | R1 | 🟡 HIGH |
| OPS-10 | Thiết lập GitHub Actions CI cơ bản | R4 | 🟢 MEDIUM |

**Definition of Done Sprint 1:**
- [ ] `docker compose up` chạy thành công, 4 service đều healthy
- [ ] Truy cập được MinIO Console (localhost:9001) và Airflow UI (localhost:8080)
- [ ] CI chạy được trên GitHub (dù chưa có tests)

---

## 🚀 Sprint 2 — Thu thập & Lưu trữ dữ liệu (Tuần 2)

**Mục tiêu:** Pipeline fetch dữ liệu chạy được end-to-end, lưu Bronze và Silver thành công.

| Task ID | Mô tả | Role | Ưu tiên |
|---|---|---|---|
| ING-03 | Viết `yfinance_fetcher.py` | R1 | 🔴 CRITICAL |
| ING-04 | Viết `vnstock_fetcher.py` | R1 | 🔴 CRITICAL |
| ING-05 | Viết `validators.py` | R1 | 🔴 CRITICAL |
| ING-06 | Viết `minio_client.py` | R1 | 🔴 CRITICAL |
| ING-07 | Triển khai retry logic | R1 | 🟡 HIGH |
| ING-08 | Cấu trúc thư mục Bronze trong MinIO | R1 | 🟡 HIGH |
| ING-09 | Logging đầy đủ cho mỗi lần fetch | R1 | 🟡 HIGH |
| PROC-01 | Viết `silver_transformer.py` | R2 | 🔴 CRITICAL |
| PROC-02 | Lưu Silver ra MinIO | R2 | 🔴 CRITICAL |
| ING-10 | Unit tests cho ingestion | R1 | 🟡 HIGH |
| PROC-03 | Unit tests cho transformer | R2 | 🟡 HIGH |

**Definition of Done Sprint 2:**
- [ ] Fetch thành công 10 mã cổ phiếu (5 VN + 5 US)
- [ ] File Bronze và Silver có mặt đúng đường dẫn trong MinIO
- [ ] Unit tests coverage ≥ 70% cho module ingestion và cleaner

---

## ⚙️ Sprint 3 — Xử lý & Phát hiện tín hiệu (Tuần 3)

**Mục tiêu:** Tính được đầy đủ chỉ số kỹ thuật, phát hiện và lưu tín hiệu vào PostgreSQL.

| Task ID | Mô tả | Role | Ưu tiên |
|---|---|---|---|
| PROC-04 | Tính SMA 20/50/200, EMA 12/26 | R2 | 🔴 CRITICAL |
| PROC-05 | Tính RSI 14, MACD, Bollinger Bands | R2 | 🔴 CRITICAL |
| PROC-06 | Tính Volume SMA & Volume Ratio | R2 | 🟡 HIGH |
| PROC-07 | Logic phát hiện tín hiệu (7 loại) | R2 | 🔴 CRITICAL |
| PROC-08 | Lưu kết quả vào PostgreSQL | R2 | 🔴 CRITICAL |
| PROC-09 | Unit tests cho indicators & signals | R2 | 🟡 HIGH |
| OPS-06 | Viết Airflow DAG (5 tasks) | R4 | 🔴 CRITICAL |
| OPS-07 | Cấu hình cron schedule | R4 | 🟡 HIGH |
| OPS-08 | Airflow Connections (MinIO, Postgres) | R4 | 🟡 HIGH |
| PROC-10 | Benchmark hiệu suất | R2 | 🟢 MEDIUM |

**Definition of Done Sprint 3:**
- [ ] Chỉ số tính ra khớp TradingView (sai số < 0.01%)
- [ ] Airflow DAG chạy end-to-end thành công 1 lần thủ công
- [ ] Dữ liệu Gold có trong bảng PostgreSQL

---

## 🎯 Sprint 4 — Cảnh báo & Dashboard (Tuần 4)

**Mục tiêu:** Hệ thống chạy hoàn chỉnh tự động, gửi cảnh báo và hiển thị dashboard.

| Task ID | Mô tả | Role | Ưu tiên |
|---|---|---|---|
| ALERT-01 | Đăng ký Telegram Bot | R3 | 🔴 CRITICAL |
| ALERT-02 | Viết `telegram_bot.py` | R3 | 🔴 CRITICAL |
| ALERT-03 | Template tin nhắn cảnh báo | R3 | 🔴 CRITICAL |
| ALERT-04 | Deduplication logic | R3 | 🟡 HIGH |
| DASH-01 | Khung giao diện Streamlit | R3 | 🟡 HIGH |
| DASH-02 | Biểu đồ nến + Overlay chỉ số | R3 | 🟡 HIGH |
| DASH-03 | Panel RSI và MACD | R3 | 🟡 HIGH |
| DASH-04 | Bảng lịch sử cảnh báo | R3 | 🟡 HIGH |
| OPS-09 | Airflow thông báo khi DAG thất bại | R4 | 🟡 HIGH |
| OPS-11 | Pre-commit hooks | R4 | 🟢 MEDIUM |
| ALERT-05 | Integration test luồng cảnh báo | R3 | 🟡 HIGH |
| DASH-05 | Trang so sánh hiệu suất nhiều mã | R3 | 🟢 MEDIUM |

**Definition of Done Sprint 4 = MVP Complete:**
- [ ] DAG chạy tự động đúng lịch (thứ Hai–Sáu lúc 18:00)
- [ ] Nhận được tin nhắn Telegram khi có tín hiệu
- [ ] Dashboard hiển thị biểu đồ và cảnh báo
- [ ] Toàn bộ CI pass

---

## 📊 Backlog (Future - Sau MVP)

| Ý tưởng | Độ phức tạp | Giá trị |
|---|---|---|
| Streaming real-time với Kafka + Spark | Cao | Cao |
| Backtesting chiến lược giao dịch | Cao | Cao |
| Phân tích sentiment tin tức (NLP) | Rất cao | Trung bình |
| Thêm chỉ số: Ichimoku, Stochastic, ATR | Trung bình | Trung bình |
| Hỗ trợ crypto (Binance API) | Thấp | Cao |
| Export báo cáo PDF định kỳ | Trung bình | Thấp |
| Web app với xác thực người dùng | Cao | Thấp |
