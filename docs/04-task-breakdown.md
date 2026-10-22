# ✅ Phân Công Công Việc Chi Tiết (Task Breakdown by Role)

## 🔵 Role 1: Data Ingestion Engineer

### Sprint 1 — Thiết lập nền tảng thu thập
- [ ] **ING-01** Cài đặt và cấu hình thư viện: `yfinance`, `vnstock`, `pyarrow`, `minio`
- [ ] **ING-02** Viết `config/symbols.yaml` — danh sách mã cổ phiếu cần theo dõi và khung thời gian
- [ ] **ING-03** Viết `ingestion/fetchers/yfinance_fetcher.py` — lấy dữ liệu OHLCV theo ngày/1d
- [ ] **ING-04** Viết `ingestion/fetchers/vnstock_fetcher.py` — lấy dữ liệu sàn HOSE/HNX
- [ ] **ING-05** Viết `ingestion/validators.py` — kiểm tra schema, loại bỏ dòng null, phát hiện outlier

### Sprint 2 — Lưu trữ Bronze & Xử lý lỗi
- [ ] **ING-06** Viết `ingestion/storage/minio_client.py` — kết nối và upload file lên MinIO
- [ ] **ING-07** Triển khai retry logic (tối đa 3 lần, exponential backoff) khi API lỗi
- [ ] **ING-08** Đặt tên file có cấu trúc: `bronze/{symbol}/{YYYY-MM-DD}/raw.parquet`
- [ ] **ING-09** Ghi log cho mỗi lần fetch: symbol, số dòng, trạng thái, thời gian
- [ ] **ING-10** Viết unit tests cho `validators.py` và `yfinance_fetcher.py`

### Tiêu chí hoàn thành (Definition of Done)
- Fetch thành công ≥ 10 mã, lưu đúng cấu trúc Bronze
- Tất cả unit tests pass
- Log có đủ thông tin để debug khi lỗi

---

## 🟢 Role 2: Data Processing Engineer

### Sprint 1 — Làm sạch dữ liệu (Bronze → Silver)
- [ ] **PROC-01** Viết `processing/cleaners/silver_transformer.py`
  - Chuẩn hoá kiểu dữ liệu (float64 cho giá, int64 cho volume)
  - Điền giá trị thiếu theo phương pháp forward-fill
  - Chuyển đổi timestamp về UTC+7
  - Loại bỏ dòng trùng lặp
- [ ] **PROC-02** Lưu Silver ra MinIO: `silver/{symbol}/{YYYY}/{MM}/data.parquet`
- [ ] **PROC-03** Viết unit tests cho từng bước làm sạch

### Sprint 2 — Tính chỉ số kỹ thuật (Silver → Gold)
- [ ] **PROC-04** Viết `processing/indicators/moving_averages.py`
  - SMA 20, SMA 50, SMA 200
  - EMA 12, EMA 26
- [ ] **PROC-05** Viết `processing/indicators/oscillators.py`
  - RSI 14 (Relative Strength Index)
  - MACD (12, 26, 9) — tính `macd`, `macd_signal`, `macd_hist`
  - Bollinger Bands (20, 2 sigma) — `bb_upper`, `bb_middle`, `bb_lower`
- [ ] **PROC-06** Viết `processing/indicators/volume.py`
  - Volume SMA 20
  - Volume ratio (volume / vol_sma20)

### Sprint 3 — Phát hiện tín hiệu giao dịch
- [ ] **PROC-07** Viết `processing/signals/detector.py`
  - Golden Cross: SMA20 cắt lên SMA50 (từ dưới lên)
  - Death Cross: SMA20 cắt xuống SMA50 (từ trên xuống)
  - RSI Oversold: RSI < 30
  - RSI Overbought: RSI > 70
  - Volume Spike: volume_ratio > 2.0
  - BB Breakout Upper: close > bb_upper
  - BB Breakout Lower: close < bb_lower
- [ ] **PROC-08** Lưu kết quả vào PostgreSQL bảng `stock_indicators` và `stock_signals`
- [ ] **PROC-09** Viết unit tests cho mỗi loại tín hiệu (có fixture data)
- [ ] **PROC-10** Benchmark hiệu suất: xử lý 50 mã × 2 năm dữ liệu trong < 60 giây

### Tiêu chí hoàn thành
- Kết quả tính toán trùng khớp với TradingView (sai số < 0.01%)
- Tất cả tests pass
- Schema Gold Layer đã được Role 3 xác nhận

---

## 🟡 Role 3: Data Serving & Alerting Engineer

### Sprint 1 — Telegram Bot cơ bản
- [ ] **ALERT-01** Đăng ký Telegram Bot qua @BotFather, lưu token vào `.env`
- [ ] **ALERT-02** Viết `alerting/telegram_bot.py` — hàm gửi tin nhắn với retry
- [ ] **ALERT-03** Thiết kế template tin nhắn cho từng loại tín hiệu:
  ```
  🔔 [SIGNAL TYPE] - {SYMBOL}
  📈 Giá hiện tại: {CLOSE} ({CHANGE}%)
  📊 Tín hiệu: {SIGNAL_DESCRIPTION}
  🕐 Thời gian: {TIMESTAMP}
  💡 {RECOMMENDATION}
  ```
- [ ] **ALERT-04** Viết `alerting/deduplicator.py` — chống gửi trùng cùng tín hiệu trong 1 phiên
- [ ] **ALERT-05** Viết integration test: giả lập signal → kiểm tra tin nhắn được gửi đúng

### Sprint 2 — Dashboard Streamlit
- [ ] **DASH-01** Dựng khung giao diện `dashboard/app.py`
  - Sidebar: chọn mã cổ phiếu, khung thời gian, chỉ số muốn xem
  - Main area: biểu đồ nến + chỉ số kỹ thuật
- [ ] **DASH-02** Tích hợp biểu đồ nến (candlestick) bằng `plotly`
- [ ] **DASH-03** Overlay chỉ số lên biểu đồ (SMA, Bollinger Bands)
- [ ] **DASH-04** Panel RSI và MACD bên dưới biểu đồ chính
- [ ] **DASH-05** Bảng lịch sử cảnh báo (10 cảnh báo gần nhất)
- [ ] **DASH-06** Trang so sánh hiệu suất: đường biểu diễn % return của nhiều mã

### Tiêu chí hoàn thành
- Bot gửi được tin nhắn đúng format trong < 5 giây sau khi có tín hiệu
- Dashboard load trong < 3 giây
- Không có trường hợp gửi tin nhắn trùng lặp trong 24 giờ

---

## 🔴 Role 4: DevOps & Orchestration Engineer

### Sprint 1 — Dựng môi trường Docker
- [ ] **OPS-01** Viết `docker-compose.yml` với các service:
  - `minio`: MinIO Object Storage (port 9000, 9001)
  - `postgres`: PostgreSQL 15 (port 5432)
  - `airflow`: Airflow Webserver + Scheduler (port 8080)
  - `streamlit`: Dashboard (port 8501)
- [ ] **OPS-02** Viết `Dockerfile` cho service Python (cài đặt tất cả dependencies)
- [ ] **OPS-03** Viết `.env.example` với tất cả biến cần điền
- [ ] **OPS-04** Viết script `scripts/setup.sh` để khởi tạo MinIO buckets và PostgreSQL schema lần đầu
- [ ] **OPS-05** Viết tài liệu `docs/SETUP.md` — hướng dẫn từng bước cho thành viên mới

### Sprint 2 — Airflow DAGs
- [ ] **OPS-06** Viết DAG `orchestration/dags/daily_stock_pipeline.py`
  - Task 1: `fetch_raw_data` — chạy mỗi ngày lúc 18:00 (sau khi thị trường VN đóng cửa)
  - Task 2: `clean_and_normalize` — phụ thuộc Task 1
  - Task 3: `calculate_indicators` — phụ thuộc Task 2
  - Task 4: `detect_signals` — phụ thuộc Task 3
  - Task 5: `send_alerts` — phụ thuộc Task 4
- [ ] **OPS-07** Cấu hình cron schedule: `0 18 * * 1-5` (thứ Hai đến thứ Sáu, 18:00)
- [ ] **OPS-08** Thiết lập Airflow Connections: MinIO, PostgreSQL, Telegram
- [ ] **OPS-09** Cấu hình email/Telegram thông báo khi DAG thất bại

### Sprint 3 — CI/CD & Code Quality
- [ ] **OPS-10** Thiết lập GitHub Actions workflow `.github/workflows/ci.yml`
  - Linting: `ruff` hoặc `flake8`
  - Type checking: `mypy`
  - Unit tests: `pytest` với coverage report
- [ ] **OPS-11** Cấu hình pre-commit hooks (black, isort, ruff)
- [ ] **OPS-12** Thiết lập branch protection rules trên GitHub

### Tiêu chí hoàn thành
- `docker compose up` chạy thành công và tất cả service healthy
- DAG chạy end-to-end không lỗi với dữ liệu thật
- CI pass trên mọi PR trước khi merge
