# 🏗️ Kiến Trúc Hệ Thống (Architecture)

## 1. Sơ đồ tổng thể

```
┌─────────────────────────────────────────────────────────────┐
│                    NGUỒN DỮ LIỆU                            │
│   yfinance (US/Global)  │  vnstock (VN)  │  Alpha Vantage   │
└──────────────┬──────────────────────────────────────────────┘
               │ Pull theo lịch
               ▼
┌─────────────────────────────────────────────────────────────┐
│              INGESTION LAYER (Thu thập)                      │
│          Python Fetcher  +  Retry Logic                      │
└──────────────┬──────────────────────────────────────────────┘
               │ Ghi thô (JSON / Parquet)
               ▼
┌─────────────────────────────────────────────────────────────┐
│              STORAGE - DATA LAKE (MinIO)                     │
│  ┌──────────┐   ┌──────────┐   ┌──────────────────────┐    │
│  │  BRONZE  │→  │  SILVER  │→  │         GOLD         │    │
│  │ Raw JSON │   │ Cleaned  │   │  Indicators + Signals│    │
│  │ Parquet  │   │ Parquet  │   │  PostgreSQL / DuckDB │    │
│  └──────────┘   └──────────┘   └──────────────────────┘    │
└──────────────┬──────────────────────────────────────────────┘
               │
       ┌───────┴────────┐
       ▼                ▼
┌─────────────┐  ┌─────────────────────┐
│  ALERTING   │  │    DASHBOARD        │
│ Telegram Bot│  │  Streamlit App      │
└─────────────┘  └─────────────────────┘

               ĐIỀU PHỐI: Apache Airflow (DAGs)
```

## 2. Mô hình lưu trữ Medallion

### 🥉 Bronze Layer — Dữ liệu thô
- **Vị trí:** `minio://bronze/{symbol}/{YYYY-MM-DD}/raw.parquet`
- **Nội dung:** Dữ liệu nguyên bản từ API, không thay đổi
- **Format:** Parquet (nén Snappy)
- **Retention:** 2 năm

### 🥈 Silver Layer — Dữ liệu đã làm sạch
- **Vị trí:** `minio://silver/{symbol}/{YYYY}/{MM}/data.parquet`
- **Nội dung:** Chuẩn hoá schema, xử lý thiếu dữ liệu, chuyển múi giờ
- **Schema:**
  ```
  timestamp (datetime UTC+7), open (float), high (float),
  low (float), close (float), volume (int64), symbol (str)
  ```

### 🥇 Gold Layer — Dữ liệu phân tích
- **Vị trí:** PostgreSQL / ClickHouse (bảng `stock_indicators`)
- **Nội dung:** Tất cả chỉ số kỹ thuật đã tính toán
- **Schema:**
  ```
  timestamp, symbol, close, sma20, sma50, sma200,
  ema12, ema26, rsi14, macd, macd_signal, macd_hist,
  bb_upper, bb_middle, bb_lower, volume, vol_sma20,
  signal_type, signal_strength
  ```

## 3. Tech Stack

| Lớp | Công nghệ | Lý do chọn |
|---|---|---|
| **Nguồn dữ liệu** | yfinance, vnstock | Miễn phí, dễ dùng, đủ cho MVP |
| **Ngôn ngữ** | Python 3.11+ | Hệ sinh thái phân tích dữ liệu phong phú |
| **Data Lake Storage** | MinIO | Tương thích S3 API, chạy local bằng Docker |
| **Data Processing** | DuckDB + Polars | Nhanh, single-node, không cần cluster |
| **Database (Gold)** | PostgreSQL | Ổn định, dễ dùng, hỗ trợ time-series tốt |
| **Orchestration** | Apache Airflow | Chuẩn ngành, trực quan, hỗ trợ retry |
| **Alerting** | Telegram Bot API | Miễn phí, thông báo tức thì |
| **Dashboard** | Streamlit | Python thuần, prototype nhanh |
| **Container** | Docker + Docker Compose | Môi trường nhất quán, dễ triển khai |

## 4. Luồng dữ liệu chi tiết

```
[Airflow DAG: daily_stock_pipeline]
    │
    ├─→ Task 1: fetch_raw_data
    │       Gọi API → Lưu Bronze (MinIO)
    │
    ├─→ Task 2: clean_and_normalize   (phụ thuộc Task 1)
    │       Đọc Bronze → Làm sạch → Lưu Silver (MinIO)
    │
    ├─→ Task 3: calculate_indicators  (phụ thuộc Task 2)
    │       Đọc Silver → Tính SMA/RSI/MACD... → Lưu Gold (PostgreSQL)
    │
    ├─→ Task 4: detect_signals        (phụ thuộc Task 3)
    │       Đọc Gold → Phát hiện tín hiệu → Lưu bảng alerts
    │
    └─→ Task 5: send_alerts           (phụ thuộc Task 4)
            Đọc bảng alerts → Gửi Telegram Bot
```
