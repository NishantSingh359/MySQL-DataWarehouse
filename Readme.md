# Data Warehouse (MySQL)

This project implements a **layered Data Warehouse architecture** using **MySQL**.  
It follows industry-standard **Bronze → Silver → Gold** layers and supports **multiple execution methods** using `.bat` scripts.

---

## 🧱 Architecture Overview

Source CSV Files <br>
↓ <br>
Bronze Layer (Raw Ingestion) <br>
↓ <br>
Silver Layer (Clean & Standardized) <br>
↓ <br>
Gold Layer (Business-Ready Tables) <br>

---

## 📁 Project Structure

DATAWAREHOUSE-MYSQL/ <br>
│ <br>
├── data/ <br>
│ ├── crm/ <br>
│ │ ├── cust_info.csv <br>
│ │ ├── prd_info.csv <br>
│ │ └── sales_details.csv <br>
│ │ <br>
│ └── erp/ <br>
│ ├── cust_loc.csv <br>
│ ├── cust_per_info.csv <br>
│ └── prd_cate.csv <br>
│ <br>
├── scripts/ <br>
│ ├── run_bronze.bat <br>
│ ├── run_silver.bat <br>
│ ├── run_gold.bat <br>
│ ├── run_dw.bat <br>
│ └── run_test_gold.bat <br>
│ <br>
├── sql/ <br>
│ ├── bronze.sql <br>
│ ├── silver.sql <br>
│ └── gold.sql <br>
| <br>
├── test/ <br>
│ └── test_gold.sql <br>
│ <br>
├── .gitignore <br>
└── readme.md <br>


---

## 🔹 Bronze Layer (Raw Data)

- Loads **CSV files directly into MySQL**
- No transformation applied
- Used for **audit and reprocessing**
- Uses `LOAD DATA INFILE`

📄 Script:
- `sql/bronze.sql`
- Executed via `scripts/run_bronze.bat`

---

## 🔹 Silver Layer (Cleaned Data)

- Data cleansing (null handling, data types, duplicates)
- Standardized column names
- Business keys prepared

📄 Script:
- `sql/silver.sql`
- Executed via `scripts/run_silver.bat`

---

## 🔹 Gold Layer (Business Layer)

- Aggregations
- KPIs & reporting tables
- Optimized for analytics & dashboards

📄 Script:
- `sql/gold.sql`
- Executed via `scripts/run_gold.bat`

---

## ▶️ How to Run the Data Warehouse

### Run Full Pipeline

`scripts/run_dw.bat`


## 🎯 Key Features

- Layered DW architecture
- Batch execution using .bat files
- Separate CRM and ERP sources
- Re-runnable & modular design

## 👤 Author
**Nishant Singh** <br>

_Data Analytics Student_
