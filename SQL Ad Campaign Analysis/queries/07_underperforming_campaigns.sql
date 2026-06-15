-- ============================================================
-- Query 07: Underperforming Campaign Alert Report
-- Business question: Which active campaigns are significantly
--   below benchmark and need urgent intervention?
-- Concepts: CTEs, JOINs, CASE WHEN, WHERE filtering,
--           multiple calculated columns, subquery
-- ============================================================

WITH campaign_totals AS (
    SELECT
        p.campaign_id,
        COUNT(DISTINCT p.date)                                          AS days_running,
        ROUND(SUM(p.spend), 2)                                         AS total_spend,
        SUM(p.impressions)                                              AS total_impressions,
        SUM(p.clicks)                                                   AS total_clicks,
        SUM(p.conversions)                                              AS total_conversions,
        ROUND(SUM(p.clicks) * 1.0 / NULLIF(SUM(p.impressions), 0), 4) AS ctr,
        ROUND(SUM(p.conversions) * 1.0 / NULLIF(SUM(p.clicks), 0), 4) AS cvr,
        ROUND(SUM(p.spend) / NULLIF(SUM(p.conversions), 0), 2)         AS cpa,
        -- Average daily spend
        ROUND(SUM(p.spend) / NULLIF(COUNT(DISTINCT p.date), 0), 2)    AS avg_daily_spend
    FROM daily_performance p
    GROUP BY p.campaign_id
)

SELECT
    c.campaign_id,
    c.campaign_name,
    c.client,
    c.channel,
    c.objective,
    c.status,
    c.budget,
    ct.total_spend,
    ct.days_running,
    ct.total_conversions,
    ct.cvr,
    b.benchmark_cvr,

    -- How far below benchmark (negative = underperforming)
    ROUND((ct.cvr - b.benchmark_cvr) / NULLIF(b.benchmark_cvr, 0) * 100, 1) AS cvr_vs_benchmark_pct,

    -- Budget burn rate vs campaign length
    ROUND(ct.total_spend / NULLIF(c.budget, 0) * 100, 1) AS budget_consumed_pct,

    -- Priority flag
    CASE
        WHEN ct.cvr < b.benchmark_cvr * 0.50 THEN '🔴 Critical — CVR >50% below benchmark'
        WHEN ct.cvr < b.benchmark_cvr * 0.75 THEN '🟠 High — CVR 25–50% below benchmark'
        WHEN ct.cvr < b.benchmark_cvr * 0.90 THEN '🟡 Medium — CVR 10–25% below benchmark'
        ELSE                                       '🟢 Within acceptable range'
    END AS intervention_priority

FROM campaigns c
JOIN campaign_totals ct ON c.campaign_id = ct.campaign_id
JOIN channel_benchmarks b ON c.channel = b.channel
WHERE
    -- Only campaigns with enough data to judge (at least 7 days running)
    ct.days_running >= 7
    -- Only flag those actually underperforming
    AND ct.cvr < b.benchmark_cvr * 0.90
ORDER BY
    cvr_vs_benchmark_pct ASC;
