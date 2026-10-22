"""Stock Data Pipeline & Alerting System - Streamlit Dashboard."""

import streamlit as st

st.set_page_config(
    page_title="Stock Data Pipeline Dashboard",
    page_icon="📈",
    layout="wide",
)

st.title("📈 Stock Data Pipeline & Alerting System")
st.markdown("---")

st.sidebar.header("⚙️ Tuỳ chọn")
symbol = st.sidebar.selectbox(
    "Chọn mã cổ phiếu",
    ["VNM", "VIC", "VHM", "FPT", "HPG", "AAPL", "MSFT", "GOOGL", "TSLA", "AMZN"],
)
timeframe = st.sidebar.selectbox("Khung thời gian", ["1D", "1W", "1M"])

st.subheader(f"📊 Dữ liệu mã: {symbol} ({timeframe})")
st.info(
    "Hệ thống đang hoạt động bình thường. Dữ liệu sẽ được hiển thị khi pipeline "
    "hoàn tất chu kỳ thu thập."
)

col1, col2, col3 = st.columns(3)
with col1:
    st.metric(label="MinIO Data Lake", value="Sẵn sàng (Healthy)")
with col2:
    st.metric(label="PostgreSQL Gold Layer", value="Sẵn sàng (Healthy)")
with col3:
    st.metric(label="Airflow Orchestration", value="Sẵn sàng (Healthy)")
