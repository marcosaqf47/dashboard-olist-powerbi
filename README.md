# Olist Sales Dashboard

Interactive Power BI dashboard with a complete analysis of Olist marketplace sales, covering business overview, geographic distribution, and operational performance.

## About the project

This project analyzes public data from Olist, one of Brazil's largest e-commerce marketplaces, focusing on:

- Revenue and order volume
- Geographic distribution of sales
- Operational efficiency (deliveries, delays, and reviews)

The goal is to turn raw data into actionable insights to support business decisions.

## Technologies used

- Power BI Desktop
- DAX (measures and calculated columns)
- Power Query (ETL and data modeling)
- Olist public dataset (Kaggle)

## Dashboard structure

The report is divided into 3 pages:

### 1. Overview
- Key KPIs: revenue, orders, average ticket, and average review score
- Revenue by product category
- Orders and revenue trend by month
- Revenue by payment method
- Revenue by state
- Top-performing products table

### 2. Geographic
- Brazil shape map with revenue by state
- Top 10 states by revenue
- Revenue by region
- Average shipping cost by state
- Average delivery time by state

### 3. Operations
- KPIs: delay rate, average shipping cost, average delivery time, and items per order
- On-time vs. late deliveries
- Average review score by category
- Review score distribution
- On-time vs. late deliveries by month
- Average number of installments by payment method

## Key insights

- Revenue concentration: most of the revenue comes from a few states in the Southeast (SP, MG, RJ) and South (PR, RS, SC).
- Seasonality: order volume varies throughout the year, with peaks during campaigns such as Black Friday.
- Delivery quality: the percentage of late orders and the average delivery time help identify logistics bottlenecks by state.
- Customer satisfaction: the review score distribution shows where positive reviews concentrate and which categories underperform.

## Measures and calculated columns

Key DAX measures:

- Revenue
- Orders
- Average Ticket
- Average Shipping Cost
- Delay Rate
- Average Delivery Time (days)
- Items per Order
- Average Review Score

Key calculated columns:

- Region (North, Northeast, Central-West, Southeast, South)
- State Name (state code to full name)
- Delivery Status (On time / Late)
- Approximate Score (rounded review score)

## Data source

Olist public dataset, available on Kaggle: Brazilian E-Commerce Public Dataset by Olist. It contains information on orders, payments, reviews, customers, sellers, products, and geolocation.

## How to use

1. Download the .pbix file and open it in Power BI Desktop.
2. Navigate through the pages: Overview, Geographic, and Operations.
3. Use the date and category filters to explore the data.

## Screenshots

<img width="1314" height="743" alt="Captura de tela 2026-09-21 074643" src="https://github.com/user-attachments/assets/61131f5b-b8e2-43e0-b0be-aab9eeceeedb" />
<img width="1318" height="740" alt="Captura de tela 2026-09-21 074801" src="https://github.com/user-attachments/assets/a30129cd-b8fb-4f8e-a622-4dc98ad2ae01" />
<img width="1334" height="749" alt="Captura de tela 2026-09-21 075005" src="https://github.com/user-attachments/assets/4b2e3f6f-a2bc-4263-a6e6-faa0a2bae7e6" />


## Author

Marcos Antônio - [[link do LinkedIn](https://www.linkedin.com/in/marcos-ant%C3%B4nio-b0131a429/)]
