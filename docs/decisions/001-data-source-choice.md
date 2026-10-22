# 📌 ADR-001: Lựa Chọn Nguồn Dữ Liệu

**Ngày:** 2026-10-22
**Trạng thái:** Đã chấp thuận
**Người quyết định:** Cả nhóm

## Bối cảnh
Cần chọn nguồn dữ liệu cổ phiếu phù hợp cho giai đoạn MVP.

## Các lựa chọn đã xem xét

| Nguồn | Ưu điểm | Nhược điểm |
|---|---|---|
| `yfinance` | Miễn phí, dữ liệu US + global phong phú, dễ dùng | Không chính thức, có thể bị chặn |
| `vnstock` | Dữ liệu VN chuẩn (HOSE/HNX), tiếng Việt | Chỉ hỗ trợ thị trường Việt Nam |
| Alpha Vantage (free tier) | Ổn định, có API key | Giới hạn 5 requests/phút |

## Quyết định
Dùng **cả `yfinance` và `vnstock`** với thiết kế abstract base class để dễ thay thế khi cần.

## Hệ quả
- Cần viết adapter cho từng nguồn dữ liệu
- Khi 1 nguồn lỗi có thể fallback sang nguồn khác
