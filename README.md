# 🏗️ Data Warehouse & Analytics Project  

## 📌 Overview  
This project demonstrates the design and implementation of a **modern data warehouse** using **SQL Server**, including **ETL processes, data modeling, and analytics**.  

📄 **[Full Project Documentation (Notion)](https://powerful-find-2b5.notion.site/Data-Warehouse-Project-906f748d783549d09e6d30b00bcc4647)**  

It represents an end-to-end solution built entirely from scratch on my local machine — starting with raw CSVs and finishing with **clean, business-ready datasets** that can be directly consumed by BI tools (e.g., Power BI, Tableau).  

The project follows **Medallion Architecture principles** (Bronze → Silver → Gold), ensuring a structured and scalable approach to data engineering and analytics.  

---

## 🎯 Objective  
Develop a modern data warehouse that integrates sales data from multiple sources, improves data quality, and enables **analytical reporting** to support **data-driven decision-making**.  

---

## ⚙️ Specifications  

- **Data Sources**: Two independent systems:  
  - CRM (Customer Relationship Management) — CSV export  
  - ERP (Enterprise Resource Planning) — CSV export  

- **Data Quality**:  
  - Handling missing values  
  - Deduplication  
  - Standardizing inconsistent formats  

- **Integration**:  
  - Combine CRM + ERP data into a unified **analytical data model**  
  - Ensure consistency across dimensions (customers, products, sales)  

- **Scope**:  
  - Latest dataset only (historization not required for this portfolio demo)  

- **Documentation**:  
  - Clear ERD (Entity Relationship Diagram)  
  - Metadata documentation for analytics & business stakeholders  

---

## 🏛️ Architecture  

The warehouse is designed using the **Medallion Architecture** approach:  

- **Bronze** → Raw ingested data (as-is from CRM & ERP)  
- **Silver** → Data cleaning, transformation, deduplication, normalization  
- **Gold** → Final business-friendly schema optimized for reporting  

---

## 📊 Data Model  

📌 Final schema includes:  
- **Fact Table**: Sales Fact (transactions)  
- **Dimensions**: Customer, Product, Region, Time, Sales Rep  
- **Relationships**: Star Schema for optimized analytical queries  

<img width="911" height="464" alt="image" src="https://github.com/user-attachments/assets/83b09593-412f-4e82-ae95-d6748f0bca00" />


---

## 🔧 Tools & Technologies  
- **SQL Server** (Database + ETL pipelines)  
- **T-SQL** (stored procedures, views, transformations)  
- **Excel/CSV** (raw input data sources)  
- **Power BI/Tableau (Optional)** for dashboarding layer  

---

## 📈 Results & Insights  
- Created a **centralized warehouse** combining CRM & ERP data  
- Delivered **clean, reliable datasets** for analysts & BI tools  
- Enabled faster and more accurate reporting for **sales analysis & decision-making**  

---

## 📚 Documentation  
- [ERD Diagram](https://www.notion.so/Data-Warehouse-Project-906f748d783549d09e6d30b00bcc4647?source=copy_link#24d3297375038067b7d3e5a8f9895fff)
- [Data Catalog](docs/data_catalog.md)  
- [SQL Scripts](scripts)  

---

## 🚀 Future Improvements  
- Add historization (Slowly Changing Dimensions)  
- Automate pipelines with SSIS / ADF / Airflow  
- Deploy to cloud environment (Azure Synapse or Snowflake)  

---

##🔎 Want to explore the project in detail?  
Check out the **[Full Project Walkthrough on Notion](https://powerful-find-2b5.notion.site/Data-Warehouse-Project-906f748d783549d09e6d30b00bcc4647)**.  


## 🤝 Connect  
👤 **Author:** Marwan Zidane  
🔗 [LinkedIn](your-linkedin) | [GitHub](https://github.com/JustEmzy101)  
