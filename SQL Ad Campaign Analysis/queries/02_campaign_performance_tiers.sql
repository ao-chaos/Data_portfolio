-- ============================================================
-- Query 02: Campaign Performance Tiering
-- Business question: How do campaigns segment by performance?
--   Which are top performers, which are underdelivering?
-- Concepts: CTEs, CASE WHEN, aggregations, ORDER BY
-- ============================================================

WITH campaign_totals AS (
    -- Step 1: Aggregate daily data to campaign level
    SELECT
        p.campaign_id,
        SUM(p.spend)                                                    AS total_spend,
        SUM(p.impressions)                                              AS total_impressions,
        SUM(p.clicks)                                                   AS total_clicks,
        SUM(p.conversions)                                              AS total_conversions,
        ROUND(SUM(p.spend) / NULLIF(SUM(p.conversions), 0), 2)         AS cpa,
        ROUND(SUM(p.clicks) * 1.0 / NULLIF(SUM(p.impressions), 0), 4) AS ctr,
        ROUND(SUM(p.conversions) * 1.0 / NULLIF(SUM(p.clicks), 0), 4) AS cvr
    FROM daily_performance p
    GROUP BY p.campaign_id
),

campaign_enriched AS (
    -- Step 2: Join campaign metadata and benchmark
    SELECT
        c.campaign_id,
        c.campaign_name,
        c.client,
        c.channel,
        c.objective,
        c.budget,
        ct.total_spend,
        ct.total_conversions,
        ct.ctr,
        ct.cvr,
        ct.cpa,
        ROUND(ct.total_spend / NULLIF(c.budget, 0) * 100, 1)  AS budget_utilisation_pct,
        b.benchmark_cvr
    FROM campaigns c
    JOIN campaign_totals ct ON c.campaign_id = ct.campaign_id
    JOIN channel_benchmarks b ON c.channel = b.channel
)

-- Step 3: Assign performance tier based on CVR vs channel benchmark
SELECT
    campaign_id,
    campaign_name,
    client,
    channel,
    objective,
    budget,
    total_spend,
    total_conversions,
    ctr,
    cvr,
    cpa,
    budget_utilisation_pct,
    benchmark_cvr,

    CASE
        WHEN cvr >= benchmark_cvr * 1.25 THEN 'Top Performer'
        WHEN cvr >= benchmark_cvr * 0.90 THEN 'On Track'
        WHEN cvr >= benchmark_cvr * 0.60 THEN 'Underperforming'
        ELSE                                  'At Risk'
    END AS performance_tier

FROM campaign_enriched
ORDER BY cvr DESC;
