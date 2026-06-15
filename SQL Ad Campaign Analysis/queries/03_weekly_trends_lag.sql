-- ============================================================
-- Query 03: Week-over-Week Performance Trends
-- Business question: How is overall spend and conversion volume
--   trending week-on-week? Where are the biggest swings?
-- Concepts: CTEs, DATE functions, LAG window function,
--           ROUND, calculated % change
-- ============================================================

WITH weekly_totals AS (
    -- Aggregate daily performance to ISO week
    SELECT
        STRFTIME('%Y', date)                        AS year,
        STRFTIME('%W', date)                        AS week_num,
        -- Monday of each week as a readable anchor date
        DATE(date, 'weekday 1', '-6 days')          AS week_start,
        ROUND(SUM(spend), 2)                        AS weekly_spend,
        SUM(impressions)                            AS weekly_impressions,
        SUM(clicks)                                 AS weekly_clicks,
        SUM(conversions)                            AS weekly_conversions,
        ROUND(SUM(spend) / NULLIF(SUM(conversions), 0), 2) AS weekly_cpa
    FROM daily_performance
    GROUP BY year, week_num, week_start
),

weekly_with_lag AS (
    -- Apply LAG to get prior week values for WoW comparison
    SELECT
        week_start,
        weekly_spend,
        weekly_conversions,
        weekly_cpa,

        LAG(weekly_spend, 1)       OVER (ORDER BY week_start) AS prev_week_spend,
        LAG(weekly_conversions, 1) OVER (ORDER BY week_start) AS prev_week_conversions,
        LAG(weekly_cpa, 1)         OVER (ORDER BY week_start) AS prev_week_cpa
    FROM weekly_totals
)

SELECT
    week_start,
    weekly_spend,
    weekly_conversions,
    weekly_cpa,
    prev_week_spend,
    prev_week_conversions,

    -- Week-over-week % change in spend
    CASE
        WHEN prev_week_spend IS NULL THEN NULL
        ELSE ROUND((weekly_spend - prev_week_spend) / NULLIF(prev_week_spend, 0) * 100, 1)
    END AS spend_wow_pct,

    -- Week-over-week % change in conversions
    CASE
        WHEN prev_week_conversions IS NULL THEN NULL
        ELSE ROUND((weekly_conversions - prev_week_conversions) / NULLIF(prev_week_conversions, 0) * 100, 1)
    END AS conversions_wow_pct,

    -- Signal: flag weeks with >15% swing in either direction
    CASE
        WHEN ABS((weekly_conversions - prev_week_conversions) * 1.0
             / NULLIF(prev_week_conversions, 0)) > 0.15
        THEN 'Flag — significant swing'
        ELSE 'Normal'
    END AS alert_flag

FROM weekly_with_lag
ORDER BY week_start;
