-- ============================================================
-- Query 01: Channel Performance Summary
-- Business question: Which channels deliver the best ROI,
--   and how does each compare against industry benchmarks?
-- Concepts: JOINs, aggregations, ROUND, calculated metrics
-- ============================================================

SELECT
    c.channel,
    COUNT(DISTINCT c.campaign_id)                          AS total_campaigns,
    ROUND(SUM(p.spend), 2)                                 AS total_spend,
    SUM(p.impressions)                                     AS total_impressions,
    SUM(p.clicks)                                          AS total_clicks,
    SUM(p.conversions)                                     AS total_conversions,

    -- Click-through rate
    ROUND(SUM(p.clicks) * 1.0 / NULLIF(SUM(p.impressions), 0), 4)  AS ctr,

    -- Cost per click
    ROUND(SUM(p.spend) / NULLIF(SUM(p.clicks), 0), 2)              AS cpc,

    -- Conversion rate
    ROUND(SUM(p.conversions) * 1.0 / NULLIF(SUM(p.clicks), 0), 4) AS cvr,

    -- Cost per conversion
    ROUND(SUM(p.spend) / NULLIF(SUM(p.conversions), 0), 2)         AS cpa,

    -- Benchmark CTR for comparison
    b.benchmark_ctr,

    -- Performance vs benchmark (positive = above benchmark)
    ROUND(
        (SUM(p.clicks) * 1.0 / NULLIF(SUM(p.impressions), 0)) - b.benchmark_ctr,
        4
    )                                                               AS ctr_vs_benchmark

FROM campaigns c
JOIN daily_performance p
    ON c.campaign_id = p.campaign_id
JOIN channel_benchmarks b
    ON c.channel = b.channel
GROUP BY
    c.channel, b.benchmark_ctr
ORDER BY
    total_spend DESC;
