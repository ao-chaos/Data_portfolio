"""
run_queries.py
Loads the three CSV tables into an in-memory SQLite database
and runs all 8 SQL queries, saving results to outputs/.
"""

import sqlite3
import pandas as pd
from pathlib import Path

ROOT = Path(__file__).parent
DATA = ROOT / "data"
QUERIES = ROOT / "queries"
OUTPUTS = ROOT / "outputs"
OUTPUTS.mkdir(exist_ok=True)

QUERY_FILES = [
    "01_channel_roi.sql",
    "02_campaign_performance_tiers.sql",
    "03_weekly_trends_lag.sql",
    "04_campaign_ranking_by_channel.sql",
    "05_cumulative_spend.sql",
    "06_client_summary.sql",
    "07_underperforming_campaigns.sql",
    "08_monthly_exec_summary.sql",
]

def main():
    # Load data into SQLite
    conn = sqlite3.connect(":memory:")
    pd.read_csv(DATA / "campaigns.csv").to_sql("campaigns", conn, index=False, if_exists="replace")
    pd.read_csv(DATA / "daily_performance.csv").to_sql("daily_performance", conn, index=False, if_exists="replace")
    pd.read_csv(DATA / "channel_benchmarks.csv").to_sql("channel_benchmarks", conn, index=False, if_exists="replace")
    print("✓ Data loaded into SQLite\n")

    # Run each query
    for fname in QUERY_FILES:
        sql = (QUERIES / fname).read_text()
        try:
            df = pd.read_sql_query(sql, conn)
            out_path = OUTPUTS / f"{fname.replace('.sql', '_results.csv')}"
            df.to_csv(out_path, index=False)
            print(f"✓ {fname} → {len(df)} rows → {out_path.name}")
        except Exception as e:
            print(f"✗ {fname} FAILED: {e}")

    conn.close()
    print("\nAll queries complete. Results saved to outputs/")

if __name__ == "__main__":
    main()
