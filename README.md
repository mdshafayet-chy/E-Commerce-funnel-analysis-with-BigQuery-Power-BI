# 🛒 E-Commerce Funnel Analysis Dashboard

> **End-to-end purchase funnel analytics project** built with **Google BigQuery (GA4 data)** and **Power BI** — covering conversion drop-offs, device & traffic segment behavior, geographic revenue distribution, and 3-month performance trends.

---

## Table of Contents
- [Project Overview](#-project-overview)
- [Business Questions](#-business-questions)
- [Key Findings](#-key-findings)
- [Dashboard Screenshots](#-dashboard-screenshots)
  - [Page 1 — Funnel Overview](#page-1--funnel-overview)
  - [Page 2 — Segment Analysis](#page-2--segment-analysis)
  - [Page 3 — Monthly Performance & Trends](#page-3--monthly-performance--trends)
- [Project Architecture](#-project-architecture)
- [Tech Stack](#-tech-stack)
- [SQL Queries](#-sql-queries)
- [How to Reproduce](#-how-to-reproduce)
- [Business Recommendations](#-business-recommendations)
- [Author](#-author)
- [License](#-license)

---

## 📌 Project Overview

| Item | Detail |
|---|---|
| **Data Source** | Google Analytics 4 (GA4) — BigQuery Export |
| **BigQuery Dataset** | `funnel-analysis-478313.analysis.funnel_analysis_dataset` |
| **Period Analyzed** | November 2020 – January 2021 |
| **BI Tool** | Power BI Desktop |
| **Connection Method** | BigQuery Advanced Connector → SQL Statement mode |
| **SQL Queries** | 11 BigQuery SQL queries (see `sql/` folder) |
| **Dashboard Pages** | Funnel Overview · Segment Analysis · Monthly Performance & Trends |

---

## 🎯 Business Questions

1. Where do users drop off in the purchase funnel — and at which stage is the biggest leak?
2. Which device type converts best, and how does it perform at each funnel stage?
3. Which traffic source drives the highest CVR, revenue, and average order value?
4. Which countries generate the most revenue and orders?
5. How did funnel performance change month over month?
6. How long does a typical buyer take to make a purchase decision?

---

## 🔍 Key Findings

### Funnel Overview

- **Overall Conversion Rate: 7.21%** — 61.25K product views → 5.69K purchases
- **Biggest leak: View → Add to Cart** — only **20.48%** of viewers add an item to cart (largest single drop in the funnel)
- **Second critical drop: Shipping → Payment at 59.2%**, indicating friction at the payment entry step
- **Cart Abandonment Rate: 64.77%** — nearly 2 in 3 users who add to cart never complete a purchase

### Segment Analysis

- **Best Device CVR: Mobile at 7.46%** — also the highest traffic volume (40.5% of all views)
- **Best Traffic Source CVR: Referral at 8.06%** with a $58.52 AOV — the highest quality acquisition channel
- **Organic drives the most traffic** (24.1K views) but converts at only 5.5%
- **Top Country by Revenue: United States at $112.9K** — nearly 5× the second-ranked Canada ($24.5K)
- **Shipping → Payment is the weakest funnel stage** consistently across all three devices (59–61%)

### Monthly Performance & Trends

- **Best Month: December 2020** — CVR peaked at **8.62%** with 2K purchases (holiday lift)
- **Worst Month: January 2021** — CVR dropped to **5.45%** with only 1.1K purchases
- **Median time to purchase: 39 minutes** — most buyers decide quickly after first view
- **Average time to purchase: 99 hours (~4 days)** — a small deliberate-buyer segment pulls the average up significantly

---

## 📊 Dashboard Screenshots

The dashboard contains **3 pages**, each answering a different analytical question. Screenshots are stored in the `dashboard_screenshots/` folder.

---

### Page 1 — Funnel Overview
> **KPIs:** Overall CVR · Total Orders · AOV · Cart Abandonment Rate · Total Product Views  
> **Visuals:** Purchase funnel by user count · Stage-to-stage CVR bar chart

![Funnel Overview](dashboard_screenshots/funnel_overview.png)

---

### Page 2 — Segment Analysis
> **KPIs:** Best Device CVR · Best Traffic Source CVR · Best Revenue Source · Best AOV Source · Top Country by Revenue  
> **Visuals:** CVR by device · Full funnel by device · CVR / Revenue / AOV by traffic source · Top 15 countries table

![Segment Analysis](dashboard_screenshots/segment_analysis.png)

---

### Page 3 — Monthly Performance & Trends
> **KPIs:** Best Month CVR · Worst Month CVR · Peak Purchase Month · Median & Avg Time to Purchase  
> **Visuals:** CVR line chart · Purchase volume by month · Stepwise CVR trends · Monthly funnel performance table

![Monthly Performance](dashboard_screenshots/monthly_performance_and_trends.png)

---

## 🏗️ Project Architecture

```text
ecommerce-funnel-analysis/
│
├── sql/
│   ├── 01_funnel_summary.sql
│   ├── 02_funnel_conversion_rate.sql
│   ├── 03_overall_aov.sql
│   ├── 04_device_funnel_breakdown.sql
│   ├── 05_traffic_source_performance.sql
│   ├── 06_aov_by_country.sql
│   ├── 07_countries_funnel_performance.sql
│   ├── 08_monthly_funnel_performance.sql
│   ├── 09_monthly_conversion_rates.sql
│   ├── 10_time_to_purchase_kpi.sql
│   └── 11_time_to_purchase_summary.sql
│
├── dashboard_screenshots/
│   ├── funnel_overview.jpg
│   ├── segment_analysis.jpg
│   └── monthly_performance_and_trends.jpg
│
├── powerbi/
│   └── funnel_analysis.pbix
│
└── README.md
```

---

## 🛠️ Tech Stack

| Layer | Tool |
|---|---|
| **Data Warehouse** | Google BigQuery |
| **Data Source** | GA4 Event Export |
| **Query Language** | Standard SQL (BigQuery dialect) |
| **Visualization** | Power BI Desktop |
| **Connection** | BigQuery Advanced Connector → SQL Statement mode |

---

## 📋 SQL Queries

All 11 queries are standalone — each runs independently in BigQuery and is imported directly into Power BI via the Advanced SQL Statement option.

| # | File | Purpose | Power BI Page |
|---|---|---|---|
| 01 | `01_funnel_summary.sql` | Total users at each of the 6 funnel stages | Funnel Overview |
| 02 | `02_funnel_conversion_rate.sql` | Stage-to-stage conversion rates (overall) | Funnel Overview |
| 03 | `03_overall_aov.sql` | Average Order Value across all purchases | Funnel Overview |
| 04 | `04_device_funnel_breakdown.sql` | Full 6-stage funnel CVR per device category | Segment Analysis |
| 05 | `05_traffic_source_performance.sql` | CVR, Revenue, AOV per traffic source (with JOIN) | Segment Analysis |
| 06 | `06_aov_by_country.sql` | AOV per country, ordered by AOV descending | Segment Analysis |
| 07 | `07_countries_funnel_performance.sql` | Revenue, Orders, CVR per country (with JOIN) | Segment Analysis |
| 08 | `08_monthly_funnel_performance.sql` | Stage volume per month (Nov–Jan) | Monthly Trends |
| 09 | `09_monthly_conversion_rates.sql` | Stage-to-stage CVR per month | Monthly Trends |
| 10 | `10_time_to_purchase_kpi.sql` | Avg & median minutes/hours to purchase | Monthly Trends |
| 11 | `11_time_to_purchase_summary.sql` | Per-user journey from first view to purchase | Monthly Trends |

### Key Dataset Columns Used

| Column | Description |
|---|---|
| `user_pseudo_id` | Anonymous user identifier |
| `event_name` | Funnel event: `view_item`, `add_to_cart`, `begin_checkout`, `add_shipping_info`, `add_payment_info`, `purchase` |
| `event_date` | Date string in `YYYYMMDD` format |
| `event_timestamp` | Microsecond timestamp — used for time-to-purchase calculations |
| `revenue_usd` | Revenue per purchase event |
| `transaction_id` | Unique order identifier |
| `device` | Device category (mobile / desktop / tablet) |
| `traffic_source` | Acquisition channel |
| `country` | User's country |

---

## ⚙️ How to Reproduce

### Step 1 — BigQuery

Open BigQuery and run the SQL files from the `sql/` folder. The source dataset is:
