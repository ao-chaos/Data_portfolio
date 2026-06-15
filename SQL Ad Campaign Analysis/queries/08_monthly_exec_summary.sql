-- ============================================================
-- Query 08: Monthly Executive Summary
-- Business question: What is the month-by-month account
--   performance across all channels, with MoM trend?
-- Concepts: CTEs, LAG, ROUND, GROUP BY, multiple window
--           functions, formatted for executive reporting
-- ============================================================

WITH monthly AS (
    SELECT
        STRFTIME('%Y-%m', p.date)              AS month,
        ROUND(SUM(p.spend), 2)                 AS total_spend,
        SUM(p.impressions)                     AS total_impressions,
        SUM(p.clicks)                          AS total_clicks,
        SUM(p.conversions)                     AS total_conversions,
        COUNT(DISTINCT p.campaign_id)          AS active_campaigns,
        ROUND(SUM(p.spend) / NULLIF(SUM(p.conversions), 0), 2) AS cpa
    FROM daily_performance p
    GROUP BY month
),

monthly_with_lag AS (
    SELECT
        month,
        total_spend,
        total_impressions,
        total_clicks,
        total_conversions,
        active_campaigns,
        cpa,
        LAG(total_spend, 1)       OVER (ORDER BY month) AS prev_spend,
        LAG(total_conversions, 1) OVER (ORDER BY month) AS prev_conversions,
        LAG(cpa, 1)               OVER (ORDER BY month) AS prev_cpa,

        -- Running totals for YTD view
        SUM(total_spend)       OVER (ORDER BY month ROWS UNBOUNDED PRECEDING) AS ytd_spend,
        SUM(total_conversions) OVER (ORDER BY month ROWS UNBOUNDED PRECEDING) AS ytd_conversions
    FROM monthly
)

SELECT
    month,
    active_campaigns,
    total_spend,
    total_impressions,
    total_clicks,
    total_conversions,
    cpa,

    -- Month-over-month changes
    ROUND((total_spend - prev_spend) / NULLIF(prev_spend, 0) * 100, 1)            AS spend_mom_pct,
    ROUND((total_conversions - prev_conversions) / NULLIF(prev_conversions, 0) * 100, 1) AS conv_mom_pct,
    ROUND((cpa - prev_cpa) / NULLIF(prev_cpa, 0) * 100, 1)                        AS cpa_mom_pct,

    -- YTD running totals
    ytd_spend,
    ytd_conversions,

    -- Performance signal
    CASE
        WHEN (total_conversions - prev_conversions) * 1.0 / NULLIF(prev_conversions, 0) > 0.10
            THEN 'Positive momentum'
        WHEN (total_conversions - prev_conversions) * 1.0 / NULLIF(prev_conversions, 0) < -0.10
            THEN 'Declining — review required'
        ELSE 'Stable'
    END AS monthly_signal

FROM monthly_with_lag
ORDER BY month;
