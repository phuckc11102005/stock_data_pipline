# 📏 Coding Standards & Conventions

## 1. Cấu trúc thư mục module

```
stock-data-pipeline/
├── ingestion/
│   ├── __init__.py
│   ├── fetchers/
│   │   ├── __init__.py
│   │   ├── base.py           # Abstract base class cho fetcher
│   │   ├── yfinance_fetcher.py
│   │   └── vnstock_fetcher.py
│   ├── validators.py
│   └── storage/
│       └── minio_client.py
├── processing/
│   ├── cleaners/
│   │   └── silver_transformer.py
│   ├── indicators/
│   │   ├── moving_averages.py
│   │   ├── oscillators.py
│   │   └── volume.py
│   └── signals/
│       └── detector.py
├── alerting/
│   ├── telegram_bot.py
│   └── deduplicator.py
├── orchestration/
│   └── dags/
│       └── daily_stock_pipeline.py
├── dashboard/
│   └── app.py
├── config/
│   ├── symbols.yaml
│   └── settings.py          # Đọc biến môi trường từ .env
├── tests/
│   ├── ingestion/
│   ├── processing/
│   └── alerting/
└── scripts/
    └── setup.sh
```

---

## 2. Quy chuẩn Python

### Formatting & Linting
- **Formatter:** `black` (dòng dài tối đa 88 ký tự)
- **Linter:** `ruff`
- **Type checker:** `mypy` (sử dụng type hints cho mọi hàm public)
- **Import sorter:** `isort` (tự động qua pre-commit)

### Ví dụ hàm chuẩn
```python
from typing import Optional
import polars as pl

def calculate_rsi(
    close_prices: pl.Series,
    period: int = 14,
) -> pl.Series:
    """
    Tính chỉ số RSI (Relative Strength Index).

    Args:
        close_prices: Chuỗi giá đóng cửa theo thứ tự thời gian.
        period: Số phiên tính RSI. Mặc định 14.

    Returns:
        Chuỗi RSI có cùng độ dài với đầu vào (NaN cho phần đầu chưa đủ dữ liệu).

    Raises:
        ValueError: Nếu period <= 0 hoặc close_prices có ít hơn period + 1 phần tử.
    """
    if period <= 0:
        raise ValueError(f"period phải > 0, nhận được: {period}")
    ...
```

### Đặt tên
| Đối tượng | Convention | Ví dụ |
|---|---|---|
| Module / File | `snake_case` | `yfinance_fetcher.py` |
| Class | `PascalCase` | `YFinanceFetcher` |
| Function / Method | `snake_case` | `fetch_ohlcv_data()` |
| Hằng số | `UPPER_SNAKE_CASE` | `DEFAULT_RETRY_COUNT = 3` |
| Biến | `snake_case` | `close_price`, `signal_type` |

---

## 3. Quản lý cấu hình & Secrets

```python
# config/settings.py — ĐÚNG CÁCH
from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    minio_endpoint: str
    minio_access_key: str
    minio_secret_key: str
    postgres_url: str
    telegram_bot_token: str
    telegram_chat_id: str

    class Config:
        env_file = ".env"

settings = Settings()
```

```python
# ❌ KHÔNG BAO GIỜ hardcode secrets trực tiếp trong code
TELEGRAM_TOKEN = "1234567890:ABCdef..."   # CẤM
```

---

## 4. Quy chuẩn xử lý lỗi & Logging

```python
import logging

logger = logging.getLogger(__name__)

def fetch_data(symbol: str) -> pl.DataFrame:
    logger.info("Bắt đầu fetch dữ liệu cho %s", symbol)
    try:
        data = api.get(symbol)
        logger.info("Fetch thành công %d dòng cho %s", len(data), symbol)
        return data
    except RateLimitError as e:
        logger.warning("Rate limit, thử lại sau 60 giây: %s", e)
        raise
    except Exception as e:
        logger.error("Lỗi không xác định khi fetch %s: %s", symbol, e, exc_info=True)
        raise
```

**Mức log:**
- `DEBUG`: Chi tiết kỹ thuật (chỉ dùng khi debug)
- `INFO`: Sự kiện bình thường quan trọng
- `WARNING`: Bất thường nhưng không crash
- `ERROR`: Lỗi nghiêm trọng cần xử lý
