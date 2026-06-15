-- ============================================================
-- Query 04: Campaign Ranking Within Each Channel
-- Business question: For each channel, which campaigns
--   rank highest on conversion rate? Who's top 3 per channel?
-- Concepts: CTEs, RANK() window function, PARTITION BY,
--           filtering on window function result
-- ============================================================

WITH campaign_totals AS (
    SELECT
        p.campaign_id,
        ROUND(SUM(p.spend), 2)                                          AS total_spend,
        SUM(p.conversions)                                              AS total_conversions,
        ROUND(SUM(p.conversions) * 1.0 / NULLIF(SUM(p.clicks), 0), 4) AS cvr,
        ROUND(SUM(p.spend) / NULLIF(SUM(p.conversions), 0), 2)         AS cpa
    FROM daily_performance p
    GROUP BY p.campaign_id
),

ranked AS (
    SELECT
        c.campaign_id,
        c.campaign_name,
        c.client,
        c.channel,
        c.objective,
        c.budget,
        ct.total_spend,
        ct.total_conversions,
        ct.cvr,
        ct.cpa,

        -- Rank campaigns within each channel by CVR (highest = rank 1)
        RANK() OVER (
            PARTITION BY c.channel
            ORDER BY ct.cvr DESC
        ) AS channel_cvr_rank,

        -- Also rank by total conversions volume within channel
        RANK() OVER (
            PARTITION BY c.channel
            ORDER BY ct.total_conversions DESC
        ) AS channel_volume_rank

    FROM campaigns c
    JOIN campaign_totals ct ON c.campaign_id = ct.campaign_id
)

-- Return top 3 campaigns per channel by CVR
SELECT
    channel,
    channel_cvr_rank    AS rank,
    campaign_name,
    client,
    objective,
    total_spend,
    total_conversions,
    cvr,
    cpa,
    channel_volume_rank AS volume_rank
FROM ranked
WHERE channel_cvr_rank <= 3
ORDER BY channel, channel_cvr_rank;
