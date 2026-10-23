# ─────────────────────────────────────────────────────────────
# Stage 1: builder — cài dependencies, sau đó bỏ build tools
# ─────────────────────────────────────────────────────────────
FROM python:3.11-slim AS builder

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

WORKDIR /app

# Cài thư viện hệ thống cần để build (libpq-dev cho psycopg2)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Cài dependencies vào thư mục riêng để copy sang stage cuối
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir --prefix=/install -r requirements.txt

# ─────────────────────────────────────────────────────────────
# Stage 2: runtime — image gọn nhẹ, không có build tools
# ─────────────────────────────────────────────────────────────
FROM python:3.11-slim AS runtime

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    # Trỏ Python tìm packages từ thư mục /install của builder
    PYTHONPATH=/install/lib/python3.11/site-packages

WORKDIR /app

# Chỉ cần runtime lib (không cần build-essential nữa)
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    libpq5 \
    && rm -rf /var/lib/apt/lists/*

# Copy packages đã cài từ builder stage
COPY --from=builder /install /install

# Tạo user không có quyền root để chạy app (bảo mật)
RUN groupadd --gid 1001 appgroup && \
    useradd --uid 1001 --gid appgroup --no-create-home appuser

# Copy mã nguồn (không copy .venv, .git, __pycache__...)
COPY --chown=appuser:appgroup . .

# Chuyển sang non-root user
USER appuser

# ─────────────────────────────────────────────────────────────
# Streamlit Dashboard (mặc định)
# Override CMD khi chạy service khác, ví dụ:
#   docker run ... python -m ingestion.run_pipeline
# ─────────────────────────────────────────────────────────────
EXPOSE 8501

HEALTHCHECK --interval=30s --timeout=10s --retries=3 --start-period=20s \
    CMD curl -f http://localhost:8501/_stcore/health || exit 1

CMD ["python", "-m", "streamlit", "run", "dashboard/app.py", \
     "--server.port=8501", \
     "--server.address=0.0.0.0", \
     "--server.headless=true"]
