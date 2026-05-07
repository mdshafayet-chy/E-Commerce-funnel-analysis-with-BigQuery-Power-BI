WITH country_funnel AS (
  SELECT
    COALESCE(country, 'unknown') AS country,
    user_pseudo_id,
    MAX(CASE WHEN event_name = 'view_item' THEN 1 ELSE 0 END) AS viewed,
    MAX(CASE WHEN event_name = 'purchase' THEN 1 ELSE 0 END) AS purchased
  FROM `funnel-analysis-478313.analysis.funnel_analysis_dataset`
  GROUP BY 1, 2
),
country_revenue AS (
  SELECT
    COALESCE(country, 'unknown') AS country,
    COUNT(DISTINCT transaction_id) AS orders,
    ROUND(SUM(revenue_usd), 2) AS total_revenue,
    ROUND(SAFE_DIVIDE(SUM(revenue_usd), COUNT(DISTINCT transaction_id)), 2) AS aov_usd
  FROM `funnel-analysis-478313.analysis.funnel_analysis_dataset`
  WHERE event_name = 'purchase'
  GROUP BY 1
)
SELECT
  cf.country,
  SUM(cf.viewed) AS total_views,
  SUM(cf.purchased) AS total_purchases,
  ROUND(SAFE_DIVIDE(SUM(cf.purchased), SUM(cf.viewed)) * 100, 2) AS overall_conversion_rate_pct,
  COALESCE(cr.orders, 0) AS orders,
  COALESCE(cr.total_revenue, 0) AS total_revenue,
  COALESCE(cr.aov_usd, 0) AS aov_usd
FROM country_funnel cf
LEFT JOIN country_revenue cr
  ON cf.country = cr.country
GROUP BY 1, 5, 6, 7
ORDER BY total_revenue DESC;