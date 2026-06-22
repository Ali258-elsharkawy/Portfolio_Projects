# Delivery Center — Food & Goods Operations Analysis
**SQL Server · Power BI**

A two-phase operational analysis of a Brazilian delivery network — built in 2023 as a SQL project and rebuilt in 2025 as a full Power BI dashboard after developing stronger analytical skills.

---

## The Problem

A delivery network operating across 950+ stores and 400,000+ transactions had overall performance metrics that looked acceptable. Digging into the data told a different story.

---

## What Was Found

**The headline number was hiding the real problem.**
Overall SLA sat at 0.90 — which looks healthy. When split by delivery segment, the Goods category (only ~5% of total orders) was running at 0.55 SLA. It was pulling the entire operation's average down while staying invisible inside the aggregate.

**The fleet imbalance.**
111 drivers were handling more than 10 long-distance trips (over 8km) each. At the same time, 197 contracted drivers had fewer than 5 trips over a 3-month period. The problem was not capacity — it was allocation.

**Speed was not the main issue either.**
Average fleet speed was 9 km/h. Only 10% of trips exceeded 28 km/h. The instinct would be to blame traffic. But when the slowest and fastest drivers were compared, the gap was not traffic — it was routing and workload distribution.

**A custom scoring system was built to find real performers.**
A Driver Hero Score was designed combining speed consistency, order volume, and SLA — with different thresholds for Food (100 orders / 90% SLA minimum) and Goods (40 orders / 75% SLA minimum) segments. This separated drivers who were genuinely performing from drivers who were just getting easier routes.

---

## Project Structure

```
Phase 1 — Data Engineering & SQL Analysis (2023)
→ Built a relational database from 8 raw CSV files
→ Set primary and foreign keys across orders, deliveries,
  payments, drivers, channels, stores, and hubs
→ Identified and removed 4,800+ duplicate and null records
  before any analysis began
→ Created 4 analytical views measuring revenue, lead time,
  fulfillment time, and cancellation rates by channel,
  hub, store, and driver
→ Exported a final aggregated view joining all 8 tables
  for cross-functional reporting

Phase 2 — Operational Performance Dashboard (2025)
→ Interactive Power BI dashboard with SLA tracking,
  driver utilization, and store performance analysis
→ Segment-level decomposition revealing the Goods problem
→ Custom Driver Hero Score with dynamic DAX measures
→ Week-over-week trend tracking with automatic period detection
→ Store-level flagging for underperformers needing intervention
```

---

## Key Findings

| Finding | Detail |
|---|---|
| Overall SLA | 0.90 — looks healthy |
| Goods segment SLA | 0.55 — the real problem |
| Goods share of orders | ~5% |
| Overloaded drivers | 111 (10+ long trips each) |
| Underutilized drivers | 197 (under 5 trips in 3 months) |
| Average fleet speed | 9 km/h |
| Trips exceeding 28 km/h | Only 10% |
| Critical stores (SLA below 0.20) | 4 high-volume stores |

---

## Tools Used

```
SQL Server    → Database design, data cleaning, analytical views
Power BI      → Interactive dashboard, DAX measures
DAX           → Custom Driver Hero Score, dynamic week-over-week 
                trends, segment-based SLA thresholds
```

---

## Interactive Dashboard

The Power BI file (80MB with embedded data) is available for download here:

**[Download Power BI Dashboard (.pbix)](https://drive.google.com/file/d/1raWJJ3nb0XMTy0FuGAG2-Pf_7icAJZA7/view?usp=sharing)**

Open with [Power BI Desktop](https://powerbi.microsoft.com/desktop) (free). No database connection needed — data is embedded.

---

## Data Source

Brazilian Delivery Center dataset — Kaggle
[kaggle.com/datasets/nosbielcs/brazilian-delivery-center](https://www.kaggle.com/datasets/nosbielcs/brazilian-delivery-center)

---

## About This Project

This project was built twice — first in 2023 using only SQL, and again in 2025 with Power BI after completing more advanced training. Comparing the two versions shows how the same dataset yields much deeper findings when approached with better analytical tools and more deliberate business questions.

The core lesson: aggregate metrics protect problems. The operation looked fine at the surface. It took segment-level decomposition to find what was actually happening.
