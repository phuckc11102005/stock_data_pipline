# 🧪 Testing Strategy

## 1. Phân cấp kiểm thử (Testing Pyramid)

```
        /\
       /  \   E2E Tests (ít, chạy CI nightly)
      /────\  Pipeline đầu cuối: fetch → process → alert
     /      \
    /────────\ Integration Tests (trung bình)
   /          \ Kết nối MinIO, PostgreSQL, Telegram sandbox
  /────────────\
 /              \ Unit Tests (nhiều, chạy CI mỗi PR)
/________________\ Mỗi hàm tính toán, validator, formatter
```

---

## 2. Unit Tests — theo từng Role

### Role 1: Ingestion
```python
# tests/ingestion/test_validators.py
def test_validate_ohlcv_rejects_negative_price():
    """Kiểm tra validator loại bỏ giá âm."""
    ...

def test_validate_ohlcv_fills_missing_close():
    """Kiểm tra forward-fill cho cột close bị thiếu."""
    ...

def test_fetch_retries_on_rate_limit(mock_api):
    """Kiểm tra retry đúng 3 lần khi gặp RateLimitError."""
    ...
```

### Role 2: Processing
```python
# tests/processing/test_indicators.py
def test_sma20_matches_known_values():
    """Kết quả SMA20 phải trùng với giá trị tính tay."""
    prices = [10, 11, 12, ..., 30]   # 25 giá trị
    result = calculate_sma(prices, period=20)
    assert abs(result[-1] - 20.3) < 0.001

def test_golden_cross_detected_correctly(sample_price_data):
    """Phát hiện đúng tín hiệu Golden Cross."""
    ...

def test_rsi_returns_nan_for_insufficient_data():
    """RSI trả về NaN khi chưa đủ 14 phiên."""
    ...
```

### Role 3: Alerting
```python
# tests/alerting/test_deduplicator.py
def test_same_signal_not_sent_twice_in_24h():
    """Không gửi cùng tín hiệu 2 lần trong 24 giờ."""
    ...

def test_different_symbols_both_alerted():
    """Cùng loại tín hiệu nhưng khác mã thì đều được gửi."""
    ...
```

---

## 3. Integration Tests

```python
# tests/integration/test_pipeline.py
def test_fetch_to_bronze_flow(minio_test_instance):
    """Fetch dữ liệu và kiểm tra file thật sự tồn tại trong MinIO."""
    ...

def test_bronze_to_gold_full_flow(minio_test_instance, postgres_test_db):
    """Chạy toàn bộ pipeline và kiểm tra dữ liệu Gold trong DB."""
    ...
```

---

## 4. Công cụ & Cấu hình

```toml
# pyproject.toml
[tool.pytest.ini_options]
testpaths = ["tests"]
addopts = "--cov=. --cov-report=term-missing --cov-fail-under=70"

[tool.coverage.run]
omit = ["tests/*", "scripts/*", "orchestration/dags/*"]
```

---

## 5. Dữ liệu kiểm thử (Test Fixtures)

- Lưu fixture data tại `tests/fixtures/sample_ohlcv.parquet` (30 ngày dữ liệu giả)
- **Không dùng dữ liệu thật** trong unit tests (không gọi API thật)
- Dùng `pytest-mock` để mock API calls và I/O operations
- Dùng `testcontainers` để spin up MinIO / PostgreSQL thật cho integration tests

---

## 6. Coverage Targets

| Module | Target Coverage |
|---|---|
| `ingestion/validators.py` | ≥ 90% |
| `processing/indicators/` | ≥ 85% |
| `processing/signals/detector.py` | ≥ 85% |
| `alerting/deduplicator.py` | ≥ 80% |
| Overall | ≥ 70% |
