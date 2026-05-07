WITH source_funnel AS (
  SELECT
    COALESCE(NULLIF(traffic_source, ''), '(direct)') AS traffic_source,
    user_pseudo_id,
    MAX(CASE WHEN event_name = 'view_item' THEN 1 ELSE 0 END) AS viewed,
    MAX(CASE WHEN event_name = 'add_to_cart' THEN 1 ELSE 0 END) AS added_to_cart,
    MAX(CASE WHEN event_name = 'begin_checkout' THEN 1 ELSE 0 END) AS began_checkout,
    MAX(CASE WHEN event_name = 'add_shipping_info' THEN 1 ELSE 0 END) AS added_shipping_info,
    MAX(CASE WHEN event_name = 'add_payment_info' THEN 1 ELSE 0 END) AS added_payment_info,
    MAX(CASE WHEN event_name = 'purchase' THEN 1 ELSE 0 END) AS purchased
  FROM `funnel-analysis-478313.analysis.funnel_analysis_dataset`
  GROUP BY 1, 2
),
source_revenue AS (
  SELECT
    COALESCE(NULLIF(traffic_source, ''), '(direct)') AS traffic_source,
    COUNT(DISTINCT transaction_id) AS orders,
    ROUND(SUM(revenue_usd), 2) AS total_revenue,
    ROUND(SAFE_DIVIDE(SUM(revenue_usd), COUNT(DISTINCT transaction_id)), 2) AS aov_usd
  FROM `funnel-analysis-478313.analysis.funnel_analysis_dataset`
  WHERE event_name = 'purchase'
  GROUP BY 1
)
SELECT
  sf.traffic_source,
  SUM(sf.viewed) AS total_views,
  SUM(sf.added_to_cart) AS total_add_to_cart,
  SUM(sf.began_checkout) AS total_begin_checkout,
  SUM(sf.added_shipping_info) AS total_add_shipping_info,
  SUM(sf.added_payment_info) AS total_add_payment_info,
  SUM(sf.purchased) AS total_purchases,
  ROUND(SAFE_DIVIDE(SUM(sf.purchased), SUM(sf.viewed)) * 100, 2) AS overall_conversion_rate_pct,
  ROUND(SAFE_DIVIDE(SUM(sf.added_to_cart), SUM(sf.viewed)) * 100, 2) AS view_to_cart_rate_pct,
  ROUND(SAFE_DIVIDE(SUM(sf.began_checkout), SUM(sf.added_to_cart)) * 100, 2) AS cart_to_checkout_rate_pct,
  ROUND(SAFE_DIVIDE(SUM(sf.purchased), SUM(sf.added_payment_info)) * 100, 2) AS payment_to_purchase_rate_pct,
  COALESCE(sr.orders, 0) AS orders,
  COALESCE(sr.total_revenue, 0) AS total_revenue,
  COALESCE(sr.aov_usd, 0) AS aov_usd
FROM source_funnel sf
LEFT JOIN source_revenue sr
  ON sf.traffic_source = sr.traffic_source
GROUP BY 1, 12, 13, 14
ORDER BY total_views DESC;