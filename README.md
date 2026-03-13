**Retail Sales Analytics Dashboard**

A data-driven analytics project focused on monitoring and optimizing retail sales performance. The project uses SQL and Power BI to analyze revenue, customer behavior, product trends, and discount impacts, translating insights into actionable business decisions.

**Project Overview**

Retail businesses must continuously analyze sales performance to improve revenue, understand customer preferences, and optimize product offerings.
This project aggregates and analyzes sales, customer, and product data to identify trends, highlight top-performing segments, and provide insights through an interactive Power BI dashboard.

The analysis follows an end-to-end analytics workflow:

SQL for data extraction, cleaning, aggregation, and feature engineering

Power BI for KPI reporting, sales trend visualization, and discount impact analysis

**Business Objectives**

Monitor key sales metrics such as revenue, net revenue, total customers, and orders

Identify top products, top customers, and category contributions

Evaluate geographic sales performance

Assess the impact of discounts on net revenue

Provide actionable insights to support pricing strategies and sales optimization

**Tech Stack**

SQL – Data cleaning, transformation, aggregation, and preparation for analysis

Power BI – Interactive dashboards, KPIs, and visual analytics for stakeholders

**Dataset Description**

The dataset contains tables for customer, product, sales, and store information:

Customers: demographics (age, gender, geography), engagement metrics (tenure, number of products, active member status), target variable (churn flag)

Products: product details, categories, and usage metrics

Sales: transaction history, purchase type, and frequency

Stores: branch locations and region-specific data


**Project Workflow**

A. SQL Analysis

Data cleaning and formatting

Aggregation and joining of sales, customer, and product tables

KPI calculations (total revenue, net revenue, orders, top customers, top products)

Feature engineering (product categories, revenue bands, discount segments)

B. Power BI Dashboard

The dashboard presents insights in a stakeholder-friendly format, including:

Total Revenue and Net Revenue trends

Total Customers and Orders analysis

Top Products and Top Customers

Category contribution and geographic sales performance

Discount impact analysis showing which discount ranges maximize net revenue

**Key Business Insights**

Discounts of 0–5% generate the highest net revenue

Top customers contribute disproportionately to overall revenue

Certain product categories drive the majority of sales

Regional sales performance highlights priority areas for marketing and inventory allocation

Interactive dashboard enables stakeholders to explore trends and make data-driven decisions

**Repository Structure**
Retail-Sales-Analytics-Dashboard/
│
├── data/
│   └── raw/                      # Original sales, customer, and product datasets
│
├── sql/
│   └── retail_queries.sql         # SQL scripts for data aggregation and KPI calculation
│
├── powerbi/
│   └── retail_dashboard.pbix      # Power BI dashboard file
│
├── screenshots/
│   └── dashboard.png              # Dashboard visuals
│
├── README.md
└── requirements.txt               # Optional: Python/Power BI dependencies if any

How to Run the Project
SQL

Use the .sql scripts in the /sql folder to prepare data tables for analysis

Power BI

Open the .pbix file from the /powerbi folder using Power BI Desktop

Explore KPIs, charts, and dashboards for insights

**Results**

This project delivers:

KPI-driven insights into retail sales performance

Identification of top products, top customers, and high-performing categories

Discount impact analysis to guide pricing strategy

An interactive Power BI dashboard suitable for stakeholders

Author

Pooja Dhamale
Aspiring Data Analyst
Skills: SQL | Power BI | Data Visualization

Dataset Description
