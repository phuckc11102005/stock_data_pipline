#!/bin/bash
set -e

# Khởi tạo database phụ 'airflow' nếu chưa tồn tại
echo "Initializing secondary database: airflow"
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    SELECT 'CREATE DATABASE airflow' WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'airflow')\gexec
    GRANT ALL PRIVILEGES ON DATABASE airflow TO $POSTGRES_USER;
EOSQL
echo "Secondary database airflow initialized successfully."
