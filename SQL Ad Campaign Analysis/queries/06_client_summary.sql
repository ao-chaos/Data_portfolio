-- ============================================================
-- Query 06: Client-Level Performance Summary
-- Business question: Which clients are getting the most
--   value from their campaigns? How does spend map to results?
-- Concepts: CTEs, multi-table JOINs, aggregations,
--           CASE WHEN, GROUP BY multiple columns
-- ============================================================

WITH campaign_metrics AS (
    SELECT
        p.campaign_id,
        SUM(p.spend)                                                    AS total_spend,
        SUM(p.impressions)                                              AS total_impressions,
        SUM(p.clicks)                                                   AS total_clicks,
        SUM(p.conversions)                                              AS total_conversions,
        ROUND(SUM(p.spend) / NULLIF(SUM(p.conversions), 0), 2)         AS cpa,
        ROUND(SUM(p.clicks) * 1.0 / NULLIF(SUM(p.impressions), 0), 4) AS ctr
    FROM daily_performance p
    GROUP BY p.campaign_id
)

SELECT
    c.client,
    COUNT(DISTINCT c.campaign_id)           AS total_campaigns,
    COUNT(DISTINCT c.channel)               AS channels_used,
    ROUND(SUM(cm.total_spend), 2)           AS total_spend,
    ROUND(SUM(c.budget), 2)                 AS total_budget,
    SUM(cm.total_conversions)               AS total_conversions,
    ROUND(AVG(cm.cpa), 2)                   AS avg_cpa,
    ROUND(AVG(cm.ctr), 4)                   AS avg_ctr,

    -- Budget utilisation
    ROUND(SUM(cm.total_spend) / NULLIF(SUM(c.budget), 0) * 100, 1) AS budget_util_pct,

    -- Client value tier based on total spend
    CASE
        WHEN SUM(cm.total_spend) >= 100000 THEN 'Tier 1 — Enterprise'
        WHEN SUM(cm.total_spend) >= 50000  THEN 'Tier 2 — Mid-Market'
        WHEN SUM(cm.total_spend) >= 20000  THEN 'Tier 3 — Growth'
        ELSE                                    'Tier 4 — Starter'
    END AS client_tier

FROM campaigns c
JOIN campaign_metrics cm ON c.campaign_id = cm.campaign_id
GROUP BY c.client
ORDER BY total_spend DESC;
