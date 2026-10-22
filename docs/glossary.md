# 📖 Bảng Thuật Ngữ (Glossary)

## Thuật ngữ Dữ liệu & Tài chính

| Thuật ngữ | Viết tắt | Giải thích |
|---|---|---|
| **Open, High, Low, Close, Volume** | OHLCV | Bộ dữ liệu cơ bản của một phiên giao dịch: giá mở cửa, cao nhất, thấp nhất, đóng cửa, khối lượng |
| **Simple Moving Average** | SMA | Trung bình động đơn giản: trung bình cộng của N phiên gần nhất |
| **Exponential Moving Average** | EMA | Trung bình động lũy thừa: ưu tiên dữ liệu gần hơn qua hệ số nhân |
| **Relative Strength Index** | RSI | Chỉ số sức mạnh tương đối, dao động 0–100. > 70: quá mua, < 30: quá bán |
| **Moving Average Convergence Divergence** | MACD | Chỉ số xu hướng dựa trên sự hội tụ/phân kỳ của 2 đường EMA |
| **Bollinger Bands** | BB | Dải biến động giá gồm đường giữa (SMA20) và 2 dải trên/dưới cách 2 sigma |
| **Golden Cross** | — | Tín hiệu tăng: MA ngắn hạn cắt lên trên MA dài hạn |
| **Death Cross** | — | Tín hiệu giảm: MA ngắn hạn cắt xuống dưới MA dài hạn |
| **Volume Spike** | — | Khối lượng giao dịch đột biến (thường > 2× trung bình 20 phiên) |
| **Breakout** | — | Giá phá vỡ ra ngoài vùng hỗ trợ/kháng cự hoặc Bollinger Bands |
| **Oversold / Overbought** | — | Trạng thái quá bán (RSI < 30) / quá mua (RSI > 70) |

## Thuật ngữ Kiến trúc Dữ liệu

| Thuật ngữ | Giải thích |
|---|---|
| **Data Lake** | Kho lưu trữ dữ liệu thô ở bất kỳ định dạng nào, lượng lớn, chi phí thấp |
| **Data Lakehouse** | Kết hợp Data Lake (linh hoạt, rẻ) và Data Warehouse (có cấu trúc, truy vấn nhanh) |
| **Medallion Architecture** | Mô hình tổ chức dữ liệu theo 3 lớp chất lượng tăng dần: Bronze → Silver → Gold |
| **Bronze Layer** | Dữ liệu thô gốc, chưa chỉnh sửa. Là nguồn sự thật (source of truth) |
| **Silver Layer** | Dữ liệu đã làm sạch, chuẩn hoá schema, sẵn sàng để phân tích |
| **Gold Layer** | Dữ liệu đã tổng hợp/tính toán, tối ưu cho truy vấn nghiệp vụ và báo cáo |
| **DAG** | Directed Acyclic Graph — đồ thị định hướng không có chu trình, dùng trong Airflow để mô tả pipeline |
| **ETL** | Extract, Transform, Load — Trích xuất, Biến đổi, Nạp dữ liệu |
| **Parquet** | Định dạng file dữ liệu dạng cột (columnar), nén tốt, đọc nhanh với dữ liệu lớn |
| **Partitioning** | Phân vùng dữ liệu theo một trường (ví dụ ngày, tháng) để tăng tốc truy vấn |
| **Idempotent** | Tính chất của một thao tác: chạy nhiều lần cho cùng kết quả như chạy 1 lần |
| **Backfill** | Chạy lại pipeline cho dữ liệu trong quá khứ (khi lỗi hoặc thêm mã mới) |
| **SLA** | Service Level Agreement — cam kết về thời gian hoàn thành hoặc độ sẵn sàng |

## Thuật ngữ Công cụ

| Thuật ngữ | Giải thích |
|---|---|
| **MinIO** | Object storage mã nguồn mở tương thích AWS S3 API, chạy được on-premise |
| **Apache Airflow** | Nền tảng điều phối workflow (pipeline) theo DAG, có giao diện web quản lý |
| **DuckDB** | Database phân tích trong bộ nhớ, rất nhanh, chạy trực tiếp từ Python |
| **Polars** | Thư viện xử lý DataFrame bằng Python, nhanh hơn Pandas nhiều lần |
| **Streamlit** | Framework Python để tạo web app dữ liệu tương tác nhanh, không cần frontend |
| **yfinance** | Thư viện Python lấy dữ liệu cổ phiếu từ Yahoo Finance |
| **vnstock** | Thư viện Python lấy dữ liệu cổ phiếu thị trường chứng khoán Việt Nam |
