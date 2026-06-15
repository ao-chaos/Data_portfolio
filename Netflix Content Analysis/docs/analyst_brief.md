# Streaming Content Strategy Brief
## What Disappears: Cataloguing Churn Risk, Content Gaps, and the Half-Life of Streaming Libraries

**Prepared by:** Zari Syed  
**Date:** June 2025  
**Datasets:** Netflix Titles (Kaggle, ~8,800 titles), Amazon Prime Titles (Kaggle, ~9,700 titles), Disney+ Titles (Kaggle, ~1,450 titles)  

---

## Executive Summary

The streaming industry conversation fixates on what's new. This brief examines what's at risk of disappearing — and what was never there to begin with.

Three findings stand out:

1. **24% of Netflix's library is licensed content added 6+ years after its original release date.** This segment — roughly 2,100 titles — is the highest churn-risk category. Licensing contracts in the streaming industry typically run on 2–4 year cycles; content with a 6+ year acquisition lag is overwhelmingly third-party IP that Netflix does not own, and which competitors or rights-holders can reclaim.

2. **Netflix's content growth plateaued after 2019.** The platform added over 2,000 titles in 2019 alone; by 2021 that figure had dropped to ~1,500. This is not a sign of decline — it reflects a strategic shift from volume acquisition toward original production, where Netflix controls IP permanently. The risk is that licensed content churns out faster than originals can fill the gap.

3. **Platform differentiation is real and widening.** Netflix leads on international breadth (India, South Korea, and Japan all in its top 5 content origins). Amazon Prime competes on volume. Disney+ is a fundamentally different product — a vault of legacy IP with a 9-year median content lag — and does not compete for the same audience in most genres.

---

## 1. The Content Velocity Story: Growth, Plateau, and Pivot

![Content Velocity](../outputs/figures/fig01_content_velocity.png)

Netflix added negligible content before 2015. The content arms race began in earnest in 2016, peaked in 2019, and has since moderated.

| Year | Titles Added |
|------|-------------|
| 2016 | 429 |
| 2017 | 1,188 |
| 2018 | 1,649 |
| 2019 | 2,016 |
| 2020 | 1,879 |
| 2021 | 1,498 |

The slowdown from 2019 to 2021 coincides with two factors: the COVID-19 production disruption, and Netflix's increased scrutiny of content ROI following subscriber growth concerns. The implication for library composition is significant — the titles added in the 2017–2019 surge were largely licensed acquisitions. Those contracts are now entering renewal windows, and many will not be renewed.

**Key takeaway:** A large portion of what Netflix added between 2017–2019 is now at or approaching the end of its initial licensing cycle. The next 2–3 years will determine how much of that content survives.

---

## 2. The Churn Risk Segment: What's Likely to Disappear

![Churn Risk](../outputs/figures/fig02_churn_risk.png)

Content age at acquisition is a proxy for licensing risk. Titles added to Netflix years or decades after their original release date were almost certainly not produced by Netflix — they are licensed assets, subject to contract expiry and competitive bidding.

**Breakdown of Netflix library by content lag:**

| Age at Addition | Titles | Share | Risk Profile |
|-----------------|--------|-------|-------------|
| Same year | 3,241 | 36.8% | Low — likely originals or new productions |
| 1 year | 1,585 | 18.0% | Low-medium |
| 2 years | 714 | 8.1% | Medium |
| 3–5 years | 1,119 | 12.7% | Medium-high |
| 6–10 years | 919 | 10.4% | High — contracts likely at renewal stage |
| 11–20 years | 705 | 8.0% | High — classic licensed content |
| 20+ years | 500 | 5.7% | High — legacy catalogue, often non-exclusive |

The 2,124 titles in the 6+ year lag category represent **24.1% of the entire Netflix library**. These are predominantly movies (1,787 vs 337 TV shows), reflecting the fact that film rights are more fragmented and frequently traded than television series rights.

**What this means in practice:** When a subscriber searches for a film they watched 18 months ago and finds it gone, it is almost always a title from this segment. The "Netflix graveyard" — the informal tracking of titles removed from the platform — is dominated by older licensed movies, not original content.

---

## 3. Platform Landscape: Three Different Products

![Platform Comparison](../outputs/figures/fig03_platform_comparison.png)

The three major streaming platforms are often discussed as direct competitors. The data suggests they occupy meaningfully different positions.

**Netflix** operates as a global content aggregator with a growing originals base. Its library spans 30+ countries of origin, with a 1-year median acquisition lag indicating it is successfully capturing new and near-new content.

**Amazon Prime Video** carries the largest raw catalogue (~9,700 titles) but its data reflects a single-point snapshot, limiting trend analysis. Its 3-year median lag and country concentration suggest heavier reliance on licensed content than Netflix.

**Disney+** is categorically different. With only 1,450 titles, a 9-year median content lag, and 69% US-origin content, it is not a general streaming service — it is a brand vault. Its subscribers are not browsing; they are returning to known IP. Churn risk is structurally lower because Disney owns the rights to its core catalogue outright.

The strategic implication: **Netflix's churn problem is structurally unavoidable in a way that Disney+'s is not.** Netflix must continuously acquire or produce to maintain library size. Disney+ can maintain its value proposition with a static catalogue.

---

## 4. Geography: Where the Content War is Actually Being Fought

![Country Comparison](../outputs/figures/fig04_country_comparison.png)

Netflix's competitive moat in international content is its most underappreciated asset. While Disney+ concentrates 69% of its library in US-origin content, Netflix has built meaningful depth in:

- **India** (972 titles, #2 overall) — the world's largest growth market for streaming
- **South Korea** (199 titles) — a disproportionately high cultural export impact relative to volume (Squid Game, All of Us Are Dead)
- **United Kingdom** (419 titles) — premium drama and factual content

Amazon competes in India and the UK but at lower volume. Disney+ has negligible non-US presence in its catalogue.

The geographic diversification serves two strategic purposes: it hedges against US content licensing volatility, and it taps into audiences who are chronically underserved by English-language-first platforms. Netflix originals from South Korea and India also carry lower production costs relative to US equivalents, improving margin on a per-title basis.

---

## 5. Genre Gaps: What's Missing

![Genre Comparison](../outputs/figures/fig05_genre_comparison.png)

![Library Age Profile](../outputs/figures/fig06_library_age_profile.png)

Netflix's genre catalogue is dominated by International Movies, Dramas, and Comedies. The library age profile reveals a structural gap in pre-1980 content — classic cinema is thinly represented, a deliberate choice that reflects both rights complexity and low streaming demand among the core demographic.

**Gaps relative to competitors:**

- **Family/Animation**: Disney+ dominates this category by design. Netflix has Children & Family Movies (641 titles) but lacks the brand gravity that makes Disney+ the default for this audience.

- **Documentaries and Docuseries**: Netflix leads here (869 + 395 titles) and this represents a defensible position — documentary rights are often cheaper, production costs lower, and Netflix originals in this category (Making a Murderer, Tiger King) have demonstrated outsized cultural impact.

- **Sports content**: Absent from this dataset but a known gap. Amazon has Thursday Night Football; Netflix launched live sports in 2024. This remains the most significant content category where Netflix has not yet established a position.

---

## Methodology Notes

Content lag (the gap between a title's original release year and the year it was added to the platform) is used throughout this brief as a proxy for licensing risk. This is a conservative heuristic: some content with a long lag may be owned outright (e.g., Netflix acquiring back-catalogue rights). However, at the aggregate level, the correlation between high content lag and third-party ownership is robust.

All figures were produced using Python (pandas, matplotlib). Data sourced from Kaggle datasets maintained by the streaming community; these are crowd-sourced snapshots and may contain minor inaccuracies in dating.

The removal date analysis is modelled rather than observed — Netflix does not publish removal data. Industry licensing benchmarks (2–4 year initial terms, competitive renewal dynamics) inform the churn risk classification.

---

## Data Sources

- Netflix Titles Dataset — Shivamb, Kaggle (2021 snapshot, 8,807 titles)
- Amazon Prime Video Titles — Kaggle (2021 snapshot, 9,668 titles)
- Disney+ Titles — Kaggle (2021 snapshot, 1,450 titles)

---

*Analysis by Zari Syed · June 2025*
