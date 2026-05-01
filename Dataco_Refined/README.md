# DataCo Supply Chain Analysis

## Project Overview
End-to-end supply chain analysis of 180,519 orders across 
5 global markets using SQL Server, Python, and Power BI.

## Key Findings
- 21.6% of orders generate losses averaging -$239 each
- Discounts ($3.29M) cost more than pricing failures ($2.23M)  
- First Class shipping fails to deliver on time 100% of the time
- Synthetic data boundary identified at Oct 3, 2017
- 47% volume decline following catalog restructuring in Oct 2017

## Tools & Technologies
- **SQL Server** — data storage, star schema design, analysis
- **Python** — pandas, scipy, seaborn, statistical analysis
- **Power BI** — interactive dashboard, DAX measures

## How To View
**Dashboard:** Download DataCo_Analysis.pbix and open in 
Power BI Desktop (free at microsoft.com/powerbi)

**Notebooks:** View directly on GitHub or download and run locally

**SQL Scripts:** Execute in numbered order against SQL Server

## Data Source
DataCo Smart Supply Chain Dataset — Kaggle
Original source: Universidad del Norte, Colombia

## Project Structure
DataCo-Supply-Chain-Analysis/
├── SQL/          → Loading, cleaning, schema, analysis scripts  
├── Python/       → EDA, statistical analysis notebooks
├── PowerBI/      → Interactive dashboard (.pbix)
└── Screenshots/  → Dashboard preview images