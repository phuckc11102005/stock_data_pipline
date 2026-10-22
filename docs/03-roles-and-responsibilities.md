# 👥 Phân Công Vai Trò & Trách Nhiệm

## 1. Sơ đồ tổng quan các vai trò

```
┌──────────────────────────────────────────────────────────────┐
│                   NHÓM DỰ ÁN                                 │
│                                                              │
│  ┌─────────────────┐       ┌─────────────────┐              │
│  │   ROLE 1        │       │   ROLE 2        │              │
│  │ Data Ingestion  │       │ Data Processing │              │
│  │   Engineer      │       │   Engineer      │              │
│  └────────┬────────┘       └────────┬────────┘              │
│           │                         │                        │
│           ▼                         ▼                        │
│  ┌─────────────────┐       ┌─────────────────┐              │
│  │   ROLE 3        │       │   ROLE 4        │              │
│  │ Data Serving &  │       │  DevOps &       │              │
│  │ Alerting Eng.   │       │  Orchestration  │              │
│  └─────────────────┘       └─────────────────┘              │
└──────────────────────────────────────────────────────────────┘
```

---

## 2. Mô tả chi tiết từng vai trò

### 🔵 Role 1: Data Ingestion Engineer
**Phụ trách:** Thu thập & lưu trữ dữ liệu thô

| Hạng mục | Chi tiết |
|---|---|
| **Công nghệ chính** | Python, yfinance / vnstock, MinIO SDK, Parquet (pyarrow) |
| **Đầu vào (Input)** | Danh sách mã cổ phiếu cần theo dõi (config file) |
| **Đầu ra (Output)** | File Parquet lưu tại Bronze Layer trong MinIO |
| **Giao điểm (Interface)** | Sản phẩm của Role 1 → Role 2 đọc để xử lý tiếp |

**Trách nhiệm cụ thể:**
- Viết module gọi API lấy dữ liệu OHLCV
- Xử lý retry khi API lỗi / giới hạn rate limit
- Chuẩn hoá và validate dữ liệu trước khi ghi Bronze
- Viết unit test cho logic fetch & validate
- Tài liệu: bổ sung vào `glossary.md` các thuật ngữ API

---

### 🟢 Role 2: Data Processing Engineer
**Phụ trách:** Làm sạch dữ liệu, tính toán chỉ số kỹ thuật, phát hiện tín hiệu

| Hạng mục | Chi tiết |
|---|---|
| **Công nghệ chính** | Python, DuckDB, Polars, TA-Lib / pandas-ta |
| **Đầu vào (Input)** | File Parquet Bronze từ MinIO (do Role 1 tạo ra) |
| **Đầu ra (Output)** | Silver Parquet (đã làm sạch) + Gold records trong PostgreSQL |
| **Giao điểm (Interface)** | Sản phẩm của Role 2 → Role 3 đọc để tạo cảnh báo & dashboard |

**Trách nhiệm cụ thể:**
- Viết pipeline làm sạch dữ liệu (Bronze → Silver)
- Tính toán tất cả chỉ số kỹ thuật đã liệt kê trong requirements
- Viết logic phát hiện tín hiệu giao dịch (Golden Cross, RSI, v.v.)
- Tối ưu hiệu suất xử lý (DuckDB cho query nhanh)
- Viết unit test cho từng hàm tính chỉ số
- Tài liệu: bổ sung công thức chỉ số vào `glossary.md`

---

### 🟡 Role 3: Data Serving & Alerting Engineer
**Phụ trách:** Dashboard trực quan & hệ thống cảnh báo Telegram

| Hạng mục | Chi tiết |
|---|---|
| **Công nghệ chính** | Python, Streamlit, Telegram Bot API, PostgreSQL |
| **Đầu vào (Input)** | Bảng Gold trong PostgreSQL + bảng signals/alerts |
| **Đầu ra (Output)** | Dashboard web + tin nhắn Telegram cảnh báo |
| **Giao điểm (Interface)** | Dữ liệu đọc từ Gold Layer của Role 2 |

**Trách nhiệm cụ thể:**
- Xây dựng Telegram Bot: đăng ký bot, viết handler gửi tin nhắn
- Thiết kế template tin nhắn cảnh báo (rõ ràng, đầy đủ thông tin)
- Triển khai cơ chế chống spam (deduplication logic)
- Xây dựng dashboard Streamlit: biểu đồ nến, chỉ số, bảng cảnh báo
- Viết integration test cho luồng cảnh báo đầu-cuối
- Tài liệu: mô tả các loại tín hiệu và cách đọc hiểu

---

### 🔴 Role 4: DevOps & Orchestration Engineer
**Phụ trách:** Hạ tầng, Docker, Airflow DAGs, CI/CD, Git workflow

| Hạng mục | Chi tiết |
|---|---|
| **Công nghệ chính** | Docker, Docker Compose, Apache Airflow, GitHub Actions |
| **Đầu vào (Input)** | Các module từ Role 1, 2, 3 |
| **Đầu ra (Output)** | Hạ tầng chạy ổn định, pipeline tự động theo lịch |
| **Giao điểm (Interface)** | Điều phối toàn bộ workflow của 3 role còn lại |

**Trách nhiệm cụ thể:**
- Viết `docker-compose.yml` cho toàn bộ stack (MinIO, PostgreSQL, Airflow, Streamlit)
- Viết Airflow DAG cho pipeline hàng ngày
- Cấu hình lịch chạy (cron schedule) phù hợp với giờ thị trường
- Thiết lập GitHub Actions cho CI (lint, test tự động)
- Quản lý biến môi trường và secrets (`.env.example`)
- Onboarding tài liệu: hướng dẫn setup môi trường cho thành viên mới

---

## 3. Ma trận RACI

> **R** = Responsible (người thực hiện) | **A** = Accountable (người chịu trách nhiệm) | **C** = Consulted (được hỏi ý kiến) | **I** = Informed (được thông báo)

| Công việc | Role 1 | Role 2 | Role 3 | Role 4 |
|---|:---:|:---:|:---:|:---:|
| Thiết kế kiến trúc tổng thể | C | C | C | A/R |
| Viết module fetch dữ liệu API | **A/R** | I | I | C |
| Validate & lưu Bronze Layer | **A/R** | C | I | I |
| Pipeline làm sạch Bronze→Silver | C | **A/R** | I | I |
| Tính chỉ số kỹ thuật (TA) | I | **A/R** | C | I |
| Logic phát hiện tín hiệu | I | **A/R** | C | I |
| Telegram Bot & cảnh báo | I | I | **A/R** | C |
| Dashboard Streamlit | I | C | **A/R** | I |
| Docker Compose setup | C | C | C | **A/R** |
| Airflow DAGs | C | C | C | **A/R** |
| Viết unit tests | **R** | **R** | **R** | **A** |
| Code review & merge PR | C | C | C | **A/R** |
| Cập nhật tài liệu | **R** | **R** | **R** | **A** |

---

## 4. Quy tắc phối hợp giữa các Role

1. **Interface-first:** Mỗi Role phải thống nhất schema đầu ra (tên cột, kiểu dữ liệu) với Role nhận dữ liệu tiếp theo trước khi bắt đầu code.
2. **Không chặn nhau:** Dùng dữ liệu mẫu (fixture/mock) để phát triển song song khi chưa có dữ liệu thật từ Role trước.
3. **PR Review chéo:** Mỗi PR cần ít nhất 1 người từ Role khác review trước khi merge.
4. **Daily standup:** Cập nhật nhanh blockers hàng ngày (qua Slack/Telegram nhóm).
