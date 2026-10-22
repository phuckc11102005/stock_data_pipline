# 🚨 Rủi Ro & Kế Hoạch Giảm Thiểu (Risks)

| # | Rủi ro | Khả năng xảy ra | Mức độ ảnh hưởng | Kế hoạch giảm thiểu |
|---|---|:---:|:---:|---|
| R01 | **API bị giới hạn rate limit hoặc ngừng dịch vụ** (yfinance/vnstock thay đổi chính sách) | Trung bình | Cao | Triển khai retry với exponential backoff; chuẩn bị sẵn 1-2 nguồn dữ liệu dự phòng (Alpha Vantage, Tiingo) |
| R02 | **Dữ liệu thiếu hoặc sai lệch** (ngày lễ, cổ phiếu bị tạm dừng) | Cao | Trung bình | Validator chặt chẽ ở Bronze Layer; ghi log rõ ràng; không xoá dữ liệu thô gốc |
| R03 | **Tính toán chỉ số sai lệch** (sai công thức hoặc khung thời gian) | Thấp | Cao | Unit test có test cases so sánh với TradingView; code review chéo |
| R04 | **Airflow DAG thất bại âm thầm** mà không ai biết | Trung bình | Cao | Cấu hình email/Telegram thông báo khi task failed; thiết lập SLA alerts |
| R05 | **Môi trường Docker không nhất quán** giữa các máy thành viên | Trung bình | Trung bình | Pin phiên bản cụ thể trong `docker-compose.yml`; tài liệu setup rõ ràng |
| R06 | **Telegram Bot token bị lộ** lên GitHub | Thấp | Rất cao | Bắt buộc dùng `.env` + `.gitignore`; thiết lập pre-commit hook kiểm tra secret |
| R07 | **Phạm vi mở rộng không kiểm soát** (scope creep) | Cao | Cao | Freeze scope sau Sprint 1; mọi tính năng mới đưa vào Backlog |
| R08 | **Hiệu suất kém** khi số lượng mã tăng lên > 50 | Thấp | Trung bình | Benchmark sớm ở Sprint 3; chuyển sang ClickHouse nếu cần |
