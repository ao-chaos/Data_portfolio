# 📊 Digital Advertising Campaign Performance — SQL Analysis

[![SQL](https://img.shields.io/badge/SQL-SQLite-blue?logo=sqlite&logoColor=white)](https://www.sqlite.org/)
[![Python](https://img.shields.io/badge/Python-3.10%2B-blue?logo=python&logoColor=white)](https://www.python.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

---

## Overview

A end-to-end SQL analysis of a digital advertising account spanning 52 campaigns, 5 channels, 10 clients, and 12 months of daily performance data (~£930k total spend).

The project demonstrates practical SQL for real advertising analytics use cases 

> **Dataset:** Synthetic data generated to reflect realistic advertising performance patterns across Paid Search, Paid Social, Display, Video, and Programmatic channels.

---

## Schema

Three related tables — designed to require joins, not solvable with a single flat file.

```
campaigns                        daily_performance               channel_benchmarks
─────────────────────           ──────────────────────          ───────────────────────
campaign_id     PK              performance_id   PK             channel         PK
campaign_name                   campaign_id      FK ──────────► benchmark_ctr
client                          date                            benchmark_cpc
channel         FK ──────────► spend                           benchmark_cvr
objective                       impressions
start_date                      clicks
end_date                        conversions
budget
status
```

---

## Queries

| # | File | Business Question | Key Concepts |
|---|------|-------------------|--------------|
| 01 | [`01_channel_roi.sql`](queries/01_channel_roi.sql) | Which channels deliver the best ROI vs industry benchmarks? | JOINs, aggregations, calculated metrics |
| 02 | [`02_campaign_performance_tiers.sql`](queries/02_campaign_performance_tiers.sql) | How do campaigns segment by performance tier? | CTEs, CASE WHEN, benchmark comparison |
| 03 | [`03_weekly_trends_lag.sql`](queries/03_weekly_trends_lag.sql) | How is spend and conversions trending week-on-week? | LAG window function, % change, alert flags |
| 04 | [`04_campaign_ranking_by_channel.sql`](queries/04_campaign_ranking_by_channel.sql) | Which campaigns rank highest within each channel? | RANK() OVER PARTITION BY |
| 05 | [`05_cumulative_spend.sql`](queries/05_cumulative_spend.sql) | How is budget being consumed month by month per channel? | Running totals, SUM() OVER |
| 06 | [`06_client_summary.sql`](queries/06_client_summary.sql) | Which clients get the most value from their campaigns? | Multi-table JOINs, CASE WHEN tiering |
| 07 | [`07_underperforming_campaigns.sql`](queries/07_underperforming_campaigns.sql) | Which campaigns need urgent intervention? | CTEs, benchmark filtering, priority flags |
| 08 | [`08_monthly_exec_summary.sql`](queries/08_monthly_exec_summary.sql) | What is the month-by-month account performance? | LAG, running totals, MoM % change |

---

## Sample Output

**Query 01 — Channel ROI Summary**

| channel | total_spend | ctr | cpc | cvr | cpa | ctr_vs_benchmark |
|---------|------------|-----|-----|-----|-----|-----------------|
| Video | £287,450 | 0.0063 | £0.59 | 0.011 | £52.10 | -0.0002 |
| Paid Search | £241,830 | 0.0341 | £1.18 | 0.043 | £27.40 | -0.0009 |
| Paid Social | £198,760 | 0.0114 | £0.84 | 0.021 | £38.90 | -0.0006 |
| Programmatic | £112,340 | 0.0029 | £0.38 | 0.005 | £86.20 | +0.0001 |
| Display | £90,440 | 0.0033 | £0.44 | 0.007 | £64.70 | -0.0002 |

**Query 02 — Performance Tiers (excerpt)**

| campaign_name | channel | cvr | benchmark_cvr | performance_tier |
|--------------|---------|-----|---------------|-----------------|
| Pinnacle Tech — Conversions (Paid) Q1 | Paid Search | 0.0521 | 0.045 | Top Performer |
| Aurora Fashion — Retargeting (Paid) Q2 | Paid Social | 0.0248 | 0.022 | Top Performer |
| Verdant Foods — Brand Awareness (Disp) Q3 | Display | 0.0042 | 0.008 | On Track |

---

## Setup & Running the Queries

### Option A — SQLite (recommended, no setup required)

```bash
# Install sqlite3 if needed (usually pre-installed on Mac/Linux)
sqlite3

# Load the data
.mode csv
.import data/campaigns.csv campaigns
.import data/daily_performance.csv daily_performance
.import data/channel_benchmarks.csv channel_benchmarks

# Run a query
.read queries/01_channel_roi.sql
```

### Option B — Python + pandas (run all queries and export results)

```bash
git clone https://github.com/ao-chaos/Data_portfolio.git
cd Data_portfolio/SQL Ad Campaign Analysis

pip install pandas
python run_queries.py
```

### Option C — Any SQL client (DBeaver, TablePlus, etc.)

Import the three CSV files from `data/` as tables, then open and run any `.sql` file from `queries/`.

---

## Project Structure

```
SQL Ad Campaign Analysis/
│
├── data/
│   ├── campaigns.csv              # 52 campaigns across 5 channels, 10 clients
│   ├── daily_performance.csv      # 2,561 rows of daily metrics
│   └── channel_benchmarks.csv     # Industry benchmark CTR/CPC/CVR per channel
│
├── queries/
│   ├── 01_channel_roi.sql
│   ├── 02_campaign_performance_tiers.sql
│   ├── 03_weekly_trends_lag.sql
│   ├── 04_campaign_ranking_by_channel.sql
│   ├── 05_cumulative_spend.sql
│   ├── 06_client_summary.sql
│   ├── 07_underperforming_campaigns.sql
│   └── 08_monthly_exec_summary.sql
│
├── outputs/
│   └── query_XX_results.csv       # Pre-run results for each query
│
├── README.md
└── requirements.txt
```

---

## License

MIT License — see [LICENSE](LICENSE).

---

*Analysis by Zari Syed · June 2025*
