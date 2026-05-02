# DataCo Supply Chain Analysis
### End-to-End Analytics Project | SQL · Python · Power BI

---

## Project Overview

A comprehensive supply chain analysis of 180,519 orders across
5 global markets, conducted to develop practical skills in
data engineering, statistical analysis, and business intelligence.

The project progressed from raw CSV ingestion through database
design, exploratory analysis, statistical validation, and
interactive dashboard development — uncovering several
unexpected findings along the way including synthetic data
contamination and a major catalog restructuring event.

---

## Key Findings

**Financial**
- 21.6% of orders generate losses averaging -$239 each
- Discounts ($3.29M annually) cost 47% more than pricing failures ($2.23M)
- Two independent methods confirmed near-zero correlation between
  discount rate and order losses — losses are structural, not discount-driven
- Order profit decomposition revealed 4 distinct transaction types,
  with "Contaminated Profit" orders (Case 2) hiding losses inside
  otherwise profitable transactions

**Operational**
- First Class shipping fails to deliver on time 100% of the time
- Second Class has lower late frequency but 9x higher severity score
  than First Class — fewer but far more catastrophic delays
- 92.85% of customers who experienced delays had the majority
  of their orders arrive late — delivery failure is systemic

**Data Quality (Original Discovery)**
- Synthetic data boundary identified at October 3, 2017:
  records show an implausible pattern of exactly 68-69 orders
  per day for 91 consecutive days with zero variance
- Analysis restricted to validated real data period: Jan 2015 — Sep 30, 2017

**Catalog Strategy**
- DataCo doubled its catalog from 24 to 50 categories in 9 months
  (Apr–Dec 2017), resulting in a 47% permanent volume decline
- 18 of 26 new categories have under 3 months of data —
  insufficient for performance evaluation

---

## Tools & Technologies

| Tool | Purpose |
|---|---|
| SQL Server | Data storage, star schema design, feature engineering |
| Python (pandas, scipy, seaborn) | EDA, statistical analysis, data loading |
| Power BI | Interactive dashboard, DAX measures |

---

## Statistical Methods Used

- IQR outlier detection with Tukey fences
- Pearson correlation analysis
- D'Agostino K² normality testing (validated before Z-score safety stock)
- Pareto/ABC analysis for geographic and product segmentation
- XYZ demand volatility classification (Coefficient of Variation)
- Customer lifecycle segmentation (RFM-inspired)
- Exponential delivery severity scoring: f(x) = e^x - 1

---

## Dashboard Pages

| Page | Story |
|---|---|
| Overview | Business health at a glance |
| Financial Stream | Profit decomposition and loss analysis |
| Customer Health | Lifecycle, churn risk, and value distribution |
| Operations | Delivery performance and supply chain planning |
| Catalog & Cohort | Product segmentation and catalog expansion story |
| Geography | Market performance and regional patterns |

---

## How To View

**Interactive Dashboard**
Download `DataCo_Analysis.pbix` and open in
[Power BI Desktop](https://powerbi.microsoft.com/desktop) (free).
Data is embedded — no database connection required.

**Notebooks**
View directly on GitHub (outputs preserved inline) or
download to run locally.

**SQL Scripts**
    ├── star_schema.sql
    └──dim_population.sql

---

## Development Approach

Developed using AI-assisted coding for syntax implementation,
while all analytical decisions, hypotheses, and business
interpretations were independently formulated.

Original analytical contributions include: exponential severity
score design, synthetic data boundary discovery, 4-case order
profit decomposition, vintage cohort analysis, normality
validation before safety stock calculation, and discount
policy uniformity discovery.

---

## Data Source

DataCo Smart Supply Chain Dataset
Original publisher: Universidad del Norte, Colombia
Available at: [Kaggle](https://www.kaggle.com/datasets/shashwatwork/dataco-smart-supply-chain-for-big-data-analysis)
