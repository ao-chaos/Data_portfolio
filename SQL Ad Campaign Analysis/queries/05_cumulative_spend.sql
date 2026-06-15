-- ============================================================
-- Query 05: Cumulative Spend by Channel Over Time
-- Business question: How is budget being consumed across
--   channels month by month? Are we pacing to target?
-- Concepts: CTEs, SUM() OVER (running total window function),
--           PARTITION BY, ORDER BY within window
-- ============================================================

WITH monthly_by_channel AS (
    SELECT
        c.channel,
        STRFTIME('%Y-%m', p.date)       AS month,
        ROUND(SUM(p.spend), 2)          AS monthly_spend,
        SUM(p.conversions)              AS monthly_conversions
    FROM daily_performance p
    JOIN campaigns c ON p.campaign_id = c.campaign_id
    GROUP BY c.channel, month
)

SELECT
    channel,
    month,
    monthly_spend,
    monthly_conversions,

    -- Running total spend per channel (resets each channel)
    ROUND(
        SUM(monthly_spend) OVER (
            PARTITION BY channel
            ORDER BY month
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ), 2
    ) AS cumulative_spend,

    -- Running total conversions per channel
    SUM(monthly_conversions) OVER (
        PARTITION BY channel
        ORDER BY month
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_conversions,

    -- Month's share of channel's total annual spend
    ROUND(
        monthly_spend * 100.0 / SUM(monthly_spend) OVER (PARTITION BY channel),
        1
    ) AS pct_of_channel_annual_spend

FROM monthly_by_channel
ORDER BY channel, month;
