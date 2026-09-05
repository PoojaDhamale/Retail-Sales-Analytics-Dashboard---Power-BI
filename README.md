# 🛒 Retail Sales Performance, Customer Segmentation & Discount Optimization

An end-to-end retail analytics project: raw transactional data is cleaned, modeled, and analyzed in SQL — including RFM-based customer segmentation — with key findings explored further through an interactive Power BI dashboard covering revenue performance, customer insights, and discount impact.

---

## Overview

|             |                                                                                                                        |
| ----------- | ---------------------------------------------------------------------------------------------------------------------- |
| **Problem** | Understand what drives revenue, which customers matter most, and whether discounting is helping or hurting net revenue |
| **Data**    | 5,000 customers · 1,000 products · 50 stores · 50,000 raw transactions (India-based retail)                            |
| **Tools**   | SQL (PostgreSQL) for cleaning, feature creation, and analysis · Power BI for the dashboard                             |
| **Output**  | A multi-page interactive dashboard covering sales performance, customer segmentation, and discount strategy            |

---

## Data Cleaning & Quality Decisions

Real data-quality issues were found and handled deliberately, not silently dropped:

- **~25% of rows had a null or non-numeric `discount_percent` value.** Rather than dropping these rows, they were treated as 0% discount — the more conservative, defensible default for revenue calculations, since a missing discount is more likely a data gap than a true unknown discount.
- **9,254 rows (18.5% of all transactions) had `quantity = -1`.** Every negative-quantity row was exactly -1 (never -2, -5, etc.) with the same null-discount rate as valid rows — the signature of synthetic data noise rather than real product returns. These rows were removed once at the data-cleaning stage rather than filtering them out repeatedly in every downstream query.
- After cleaning, **~40,700 valid transactions** remain (the dashboard's "41K Total Orders" figure).

---

## SQL Analysis (`SQL.sql`)

Beyond basic aggregation, the analysis uses:

- **CTEs** to build a full RFM (Recency, Frequency, Monetary) segmentation pipeline in one readable query, rather than one long nested query
- **`NTILE(4)`** to score every customer into quartiles on recency, frequency, and monetary value independently, then combine those scores into named segments (Champions, High Value, At Risk/Churning, Medium Value)
- **`RANK()`** for product revenue ranking, and **`LAG()`** for month-over-month revenue growth
- A running-revenue window function (`SUM(...) OVER (ORDER BY sale_date)`) to track cumulative revenue over time
- Separate queries for Customer Lifetime Value, discount-bucket revenue impact, new-vs-returning customer revenue split, and store-type performance comparison

---

## SQL-Only Insights 

Some analysis lives only in `SQL.sql` and isn't currently represented as a dashboard visual — noted here for transparency:

- **RFM Customer Segmentation:** Every customer is scored into quartiles on Recency, Frequency, and Monetary value, then grouped into segments (Champions, High Value, At Risk/Churning, Medium Value) with revenue share per segment..
- **Customer Lifetime Value (CLV):** Per-customer lifetime spend.
- **Month-over-Month Revenue Growth:** Calculated via `LAG()`.

---

## Dashboard Highlights

**Sales Overview**

- ₹5.86bn total revenue, ₹5.13bn net revenue (after discounts) — a ~12% gap driven by discounting, quantified explicitly rather than left unexamined
- Revenue is concentrated: no single product dominates, but a defined "Uncategorized" product/category grouping accounts for the largest single revenue share (~28%) — flagged as a data quality gap in the source `category` field rather than a real business category, and called out directly in the dashboard rather than hidden

**Customer Insights**

- 79% of customers (4K of 5K) are returning ("Old") customers by revenue share — repeat purchasing dominates over new-customer acquisition
- Revenue is broadly distributed across the customer base: the top 10% of customers contribute only ~19% of revenue, meaning the business is not overly dependent on a small handful of accounts
- Purchase-frequency segmentation shows repeat buyers generate the largest share of net revenue, ahead of loyal (high-frequency) and low-frequency buyers
- **Geographic skew:** only 5 cities are geographically mapped, but they represent **71% of net revenue** (₹3.63bn). The remaining **29% (₹1.5bn)** comes from customers with no city recorded in the source data — a substantial share of revenue that currently cannot be mapped or analyzed geographically

**Discount Impact**

- Net revenue is highest in the 0–5% discount range and drops consistently as discount depth increases — direct evidence of diminishing returns from heavier discounting, rather than an assumption
- Store-type revenue is split across High Street (32.6%), Mall (17.3%), and Online (15.9%) — but the single largest share, **34.1%, falls into "Unknown"** store type, exceeding every identified channel. This is surfaced as the dashboard's leading data-quality gap rather than smoothed over

---

## Key Design Decisions & Honest Limitations

- **Data quality gaps ("Uncategorized" products, "Unknown" store types) are reported openly in the dashboard's own insights**, not cleaned away artificially — an accurate picture of imperfect source data was prioritized over a cosmetically cleaner but less honest one
- **Discount-null rows were imputed as 0%, a judgment call** — a different, equally defensible choice would be to exclude them entirely; this project's reasoning is documented above for transparency
- **RFM segment thresholds (quartile-based) are a standard, but not the only, segmentation approach** — different quartile cutoffs or a five-tier model would shift specific customers between segments
- **RFM segmentation and CLV exist in SQL but not yet in the dashboard** — see the "SQL-Only Insights" section above

---

## Tech Stack

`PostgreSQL` (CTEs, window functions, RFM segmentation) · `Power BI` (dashboard, DAX measures, geographic mapping)

---

## Author

**Pooja Dhamale** </br>
Artificial Intelligence and Data Science
