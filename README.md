# online-retail-sales-analysis
End-to-end sales analysis of UK online retail transactions — SQL cleaning, EDA validation, and an interactive Power BI dashboard with business recommendations.

# Online Retail Sales Performance Analysis

**Internship Deliverable — AnalystLab Africa**
**Author:** Timothy Kehinde Promise
**Tools:** PostgreSQL, Power BI

---

## Business Problem

Leadership needed clear visibility into how the business was actually performing — where revenue was coming from, which customers and markets carried the most value, and whether seasonal or operational patterns existed that should inform inventory, retention, and market-expansion decisions. This analysis was built to answer that: turning raw transaction-level data into a stakeholder-ready view of revenue drivers, customer concentration, and sales trends.

## Data Source

UK-based online retailer transaction data, covering **December 2010 – December 2011**.
Source: [UCI Online Retail Dataset](https://archive.ics.uci.edu/dataset/352/online+retail)

- Raw records: 541,909
- Cleaned records: 535,185

## Data Cleaning

Cleaning logic was built and executed in PostgreSQL.

- Removed 1,454 rows with a null product description **and** £0 unit price — junk/adjustment entries, not real sales
- Removed 4,879 exact duplicate records (same invoice, product, quantity, date, price, customer, country)
- **Kept** 130,000+ rows with missing `CustomerID` — these are legitimate, revenue-generating transactions; dropping them would have discarded real sales data just because the customer wasn't identified
- Removed negative unit prices (invalid); kept £0 prices (likely free/promotional items)
- Negative quantities kept — these represent cancelled orders (InvoiceNo starting with "C") and are needed for cancellation-rate analysis; excluded only when calculating revenue

Full logic: [`/sql/01_data_cleaning.sql`](01_data_cleaning.sql)

## Analysis Approach

- **SQL (PostgreSQL)** — data cleaning and exploratory analysis
- **Power BI** — interactive 4-page dashboard built for different stakeholder needs (Executive Summary, Sales Performance, Customer & Product, Order & Business Insights)

## Key Insights

- **Revenue peaked in November 2011**, reflecting strong pre-Christmas seasonal demand
- **Revenue grew steadily from September through November**, before an apparent drop in December — driven by the dataset ending December 9th (a partial month), not an actual decline in demand
- **The UK generates the large majority of total revenue**, significantly outperforming every other market. Because this skews any chart it appears on, UK was deliberately excluded from the country-comparison visuals so secondary markets could actually be read and compared (see Dashboard section below)
- **Netherlands generates the highest revenue among international markets despite having the fewest orders**, while **Germany leads in order volume** — pointing to different purchasing behavior across secondary markets (higher-value vs. higher-frequency customers)
- **Customer spending remained relatively stable**, with an average order value of £473.56
- **Cancellation rate sits under 2%** of all transactions — a healthy figure, not currently an operational concern
- A small number of customers account for disproportionate revenue — e.g. Customer #14646 generated ~£280K, more than double the next-highest customer

## Business Recommendations

**1. Prioritize seasonal inventory planning around Q4**
Revenue consistently builds from September and peaks in November. Stock levels, staffing, and marketing spend should scale up ahead of this window rather than reactively during it — particularly for top-selling items like the Regency Cakestand and Paper Craft Little Birdie set, which drive revenue and volume respectively.

**2. Treat Netherlands and Germany as different growth plays, not one "international" bucket**
Netherlands delivers the highest revenue per order among secondary markets with relatively low order volume — a smaller base of higher-value customers. Germany drives the highest order count but lower revenue per order — a higher-volume, lower-value market. Recommend testing premium/bundled offers in Netherlands to grow AOV further, and volume-driven promotions (free shipping thresholds, multi-buy discounts) in Germany to convert existing order frequency into higher basket size.

**3. Formalize account management for top-revenue customers**
A small number of customers (e.g. #14646 at ~£280K, more than double the next-highest) represent concentrated, high-value relationships. Recommend a dedicated retention program — proactive outreach, loyalty incentives, or account check-ins — for the top 10–20 customers by revenue, since losing even one materially impacts total revenue.

**4. No urgent action needed on cancellations, but keep monitoring**
Cancellation rate sits under 2%, which is healthy for online retail. Recommend maintaining current fulfillment/quality processes rather than reallocating resources here — this isn't currently a business risk.

**5. Exclude postage/non-product line items from merchandising decisions**
DOTCOM POSTAGE initially appeared as the top "product" by revenue — a shipping charge, not a product. Recommend any stocking or merchandising analysis explicitly filters out non-product line items to avoid skewed decisions (already corrected in this dashboard).

## Dashboard

**Page 1 — Executive Summary**
![Executive Summary](Executive_Summary.png)

**Page 2 — Sales Performance Overview**
![Sales Performance Overview](Sales_Performance.png)

**Page 3 — Customer & Product Analysis**
![Customer & Product Analysis]Customer_Product.png)

**Page 4 — Order & Business Insights**
![Order & Business Insights](Order_Business_Insights.png)

## Limitations

- Dataset covers a single 12-month window — no year-over-year comparison is possible
- December is a partial month (data ends December 9th) — excluded from trend conclusions to avoid misreading it as a seasonal decline
- Country-comparison visuals exclude the UK by design, since including it compresses every other market to an unreadable scale on the same axis. Full UK-inclusive figures are available via the KPI cards and country slicer on each dashboard page
- Customer-level totals exclude transactions with a missing `CustomerID`, even though those rows are retained in overall revenue figures — meaning total revenue and total-customers-attributed-revenue will not fully reconcile

## Repository Structure

```
online-retail-sales-analysis/
├── README.md
├── sql/
│   ├── 01_data_cleaning.sql
│   └── 02_eda_queries.sql
├── dashboard/
│   └── Online_Retail_project.pbix
└── screenshots/
    ├── 01_executive_summary.png
    ├── 02_sales_performance.png
    ├── 03_customer_product.png
    └── 04_order_business_insights.png
```
