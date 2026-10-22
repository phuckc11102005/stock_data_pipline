# 📌 ADR-002: Chiến Lược Lưu Trữ (Storage Strategy)

**Ngày:** 2026-10-22
**Trạng thái:** Đã chấp thuận

## Bối cảnh
Cần quyết định cách tổ chức và lưu trữ dữ liệu.

## Quyết định
Sử dụng **mô hình Medallion Architecture** với MinIO làm Data Lake và PostgreSQL làm serving layer.

- **Bronze:** MinIO — dữ liệu thô, không bao giờ bị ghi đè
- **Silver:** MinIO — dữ liệu làm sạch, partitioned theo tháng  
- **Gold:** PostgreSQL — dữ liệu tổng hợp, tối ưu cho query dashboard

## Lý do không dùng database ngay từ đầu cho Bronze/Silver
- File Parquet trên MinIO rẻ hơn nhiều về storage
- Dễ dàng chạy Backfill chỉ bằng cách ghi đè file
- Tương thích S3 API → dễ migrate lên cloud sau này

## Hệ quả
- Cần cài MinIO + cấu hình buckets khi setup môi trường
- Cần xử lý schema evolution (thay đổi cột) khi cập nhật Silver/Gold
