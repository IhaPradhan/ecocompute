
import streamlit as st

st.set_page_config(
    page_title="EcoCompute Dashboard",
    page_icon="🌱",
    layout="wide"
)

st.title("🌱 EcoCompute")
st.subheader("Data Center Monitoring Dashboard")

st.write(
    "Monitor server infrastructure, "
    "maintenance records, and telemetry data."
)

page = st.sidebar.selectbox(
    "Navigate",
    [
        "Overview",
        "Server Telemetry",
        "Maintenance Logs",
        "Rack and Zone Details"
    ]
)

if page == "Overview":
    st.header("Dashboard Overview")
    col1, col2, col3 = st.columns(3)
    col1.metric("Clients", "Loading...")
    col2.metric("Server Racks", "Loading...")
    col3.metric("Maintenance Logs", "Loading...")

elif page == "Server Telemetry":
    st.header("Server Telemetry")
    st.info("MongoDB telemetry integration pending.")

elif page == "Maintenance Logs":
    st.header("Maintenance Logs")
    st.info("MySQL integration pending.")

elif page == "Rack and Zone Details":
    st.header("Rack and Zone Details")
    st.info("MySQL integration pending.")
