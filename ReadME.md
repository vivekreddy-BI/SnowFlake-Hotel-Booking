# Hotel Booking Analytics on Snowflake

📑 Table of Contents  
📌 Project Overview  
🎯 Objectives  
📂 Project Structure  
🛠️ Tools & Technologies  
📐 Data Architecture  
⭐ Data Layer Design (Bronze → Silver → Gold)  
⚙️ Step-by-Step Implementation  
📊 SnowSight Dashboards  
✅ Key Outcomes  

---

📐 Data Architecture

Below diagram illustrates the end-to-end Snowflake data pipeline used in this project, showing how raw hotel booking data flows through Bronze, Silver, and Gold layers before being consumed by analytics and dashboards.

![Architecture](Docs/Hotel%20Booking%20Snowflake%20Architecture.png)


---

## 📌 Project Overview

This project demonstrates an end-to-end **data analytics pipeline in Snowflake** using hotel booking data.  
Raw CSV data is ingested into Snowflake, cleaned and standardized through layered transformations, and finally aggregated into analytics-ready tables for visualization using **SnowSight dashboards**.

The project follows a **Bronze → Silver → Gold** data modeling approach commonly used in modern data platforms.

---

## 🎯 Objectives

- Ingest raw hotel booking data into Snowflake
- Handle data quality issues such as invalid dates, emails, and negative values
- Transform and standardize data using SQL
- Build analytics-ready Gold tables
- Create KPI and trend dashboards using SnowSight
- Maintain SQL scripts and documentation using Git

---

## 📂 Project Structure

SnowFlake-Hotel-Booking/
│
├── Docs/
│ ├── Architecture diagram
│ └── SnowSight dashboard images
│
├── source/
│ └── hotel_bookings_raw.csv
│
├── SQL/
│ ├── database, file format & stage creation
│ ├── bronze table creation & data load
│ ├── silver transformation logic
│ ├── gold aggregation tables
│ └── SnowSight dashboard queries
│
└── README.md


---

## 🛠️ Tools & Technologies

- **Snowflake** – Cloud data warehouse
- **SnowSight** – Native analytics and dashboards
- **SQL** – Data ingestion, transformation, and aggregation
- **CSV Files** – Source data
- **Git & GitHub** – Version control

---

## 📐 Data Architecture

The pipeline follows a layered architecture:

- **Bronze Layer** – Raw data ingestion from CSV
- **Silver Layer** – Cleaned and validated data
- **Gold Layer** – Aggregated and analytics-ready datasets

This design improves data quality, scalability, and reporting performance.

---

## ⭐ Data Layer Design (Bronze → Silver → Gold)

### 🥉 Bronze Layer – Raw Data
- Table: `BRONZE_HB`
- Stores raw booking data as strings
- Minimal transformations
- Handles schema-on-read

### 🥈 Silver Layer – Cleaned Data
- Table: `SILVER_HB`
- Key transformations:
  - Email validation
  - Date parsing using `TRY_TO_DATE`
  - Removal of invalid date ranges
  - Standardization of city and customer names
  - Correction of booking status typos
  - Conversion of numeric values
  - Removal of negative revenue values

### 🥇 Gold Layer – Analytics Ready
- `GOLD_HOTEL_BOOKING_CLEAN`
- `GOLD_AGG_DAILY_BOOKINGS`
- `GOLD_AGG_HOTEL_CITY_SALES`

Optimized for dashboards and reporting.

---

## ⚙️ Step-by-Step Implementation

### 1. Database & File Setup
- Created database `HOTEL_BOOKINGS_DB`
- Defined CSV file format
- Created internal stage for data loading

### 2. Bronze Data Load
- Created raw table `BRONZE_HB`
- Loaded data using `COPY INTO`
- Allowed ingestion of imperfect data using `ON_ERROR = CONTINUE`

### 3. Data Quality Checks
Identified common data issues:
- Invalid email formats
- Negative booking amounts
- Invalid check-in / check-out dates
- Booking status typos
- Duplicate data


### 4. Silver Transformations
- Cleaned and standardized data
- Used safe conversion functions (`TRY_TO_DATE`, `TRY_TO_NUMBER`)
- Filtered invalid records
- Normalized booking status values
- Data Deduplication (Using `ROW_NUMBER()` function in combination with `QUALIFY`)

### 5. Gold Aggregations
- Daily booking and revenue aggregation
- Revenue by hotel city
- Clean fact-style table for reporting

### 6. Version Control
- All SQL scripts, sample data, and documentation maintained in GitHub

---

## 📊 SnowSight Dashboards

SnowSight dashboards were created using Gold layer tables.
![SnowSight Hotel Booking Dashboard](Docs/SnowSight%20Dashboard.png)


### 📌 KPIs
- Total Bookings
- Total Guests
- Average Booking Value
- Total Revenue

### 📈 Visualizations
- Daily Booking Trend (Line Chart)
- Daily Revenue Trend (Line Chart)
- Top Cities by Revenue (Bar Chart)
- Bookings by Status (Bar Chart)
- Bookings by Room Type (Bar Chart)

Dashboard screenshots are available in the `Docs` folder.

---

## ✅ Key Outcomes

- End-to-End Snowflake Pipeline implemented using SQL
- Robust Data Quality Handling using Silver layer transformations
- Analytics-ready Gold tables for reporting
- Interactive SnowSight dashboards for business insights
- Strong portfolio project demonstrating Snowflake, SQL, and Git skills

---

📌 **Note:**  
This project is created for learning and portfolio demonstration purposes.
