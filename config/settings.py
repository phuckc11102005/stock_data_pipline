"""Application configuration module."""

from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    """Application settings loaded from environment variables or .env file."""

    minio_endpoint: str = "localhost:9000"
    minio_access_key: str = "minioadmin"
    minio_secret_key: str = "minioadmin"
    minio_secure: bool = False
    postgres_url: str = "postgresql://postgres:postgres@localhost:5432/stock_pipeline"
    telegram_bot_token: str = "default_token"
    telegram_chat_id: str = "default_chat_id"
    log_level: str = "INFO"
    environment: str = "development"

    model_config = {"env_file": ".env", "extra": "ignore"}


settings = Settings()
