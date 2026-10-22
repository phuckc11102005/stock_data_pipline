# ⚠️ Giả Định & Ràng Buộc (Assumptions)

## Giả định về nguồn dữ liệu
- `yfinance` và `vnstock` đủ độ tin cậy và miễn phí cho giai đoạn MVP
- Dữ liệu lịch sử có thể fetch về tối thiểu 2 năm gần nhất
- Tần suất cập nhật 1 lần/ngày (end-of-day) là đủ cho giai đoạn MVP (chưa cần real-time)
- API không yêu cầu xác thực đặc biệt hoặc trả phí cho mức sử dụng MVP

## Giả định về môi trường
- Mỗi thành viên có Docker Desktop cài sẵn trên máy
- Máy có tối thiểu 8GB RAM và 20GB dung lượng trống để chạy toàn bộ Docker stack
- Kết nối internet ổn định để fetch dữ liệu
- Múi giờ chuẩn làm việc: UTC+7 (Việt Nam)

## Giả định về kỹ thuật
- DuckDB + Polars đủ hiệu suất để xử lý 50 mã × 2 năm dữ liệu trên single-node
- Không cần cluster Spark cho giai đoạn MVP
- PostgreSQL đủ đáp ứng tải truy vấn của dashboard với < 50 người dùng đồng thời

## Ràng buộc (Constraints)
- **Thời gian:** MVP hoàn thành trong 4 tuần
- **Chi phí:** Không phát sinh chi phí cloud (chạy hoàn toàn local bằng Docker)
- **Nhân lực:** Tối đa 4 người, mỗi người kiêm 1 role
- **Phạm vi:** Chỉ làm batch processing, chưa làm streaming real-time
- **Pháp lý:** Dữ liệu chỉ dùng để học tập, không dùng cho mục đích đầu tư thực tế
