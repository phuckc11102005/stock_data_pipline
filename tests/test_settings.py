"""Tests for application settings."""

from config.settings import settings


def test_settings_default_values():
    """Verify that default settings are correctly configured."""
    assert settings.minio_endpoint == "localhost:9000"
    assert settings.minio_access_key == "minioadmin"
    assert settings.environment == "development"
