WITH device_funnel AS (
  SELECT
    COALESCE(device, 'unknown') AS device,
    user_pseudo_id,
    MAX(CASE WHEN event_name = 'view_item' THEN 1 ELSE 0 END) AS viewed,
    MAX(CASE WHEN event_name = 'add_to_cart' THEN 1 ELSE 0 END) AS added_to_cart,
    MAX(CASE WHEN event_name = 'begin_checkout' THEN 1 ELSE 0 END) AS began_checkout,
    MAX(CASE WHEN event_name = 'add_shipping_info' THEN 1 ELSE 0 END) AS added_shipping_info,
    MAX(CASE WHEN event_name = 'add_payment_info' THEN 1 ELSE 0 END) AS added_payment_info,
    MAX(CASE WHEN event_name = 'purchase' THEN 1 ELSE 0 END) AS purchased
  FROM `funnel-analysis-478313.analysis.funnel_analysis_dataset`
  GROUP BY 1, 2
)
SELECT
  device,
  SUM(viewed) AS total_views,
  SUM(added_to_cart) AS total_add_to_cart,
  SUM(began_checkout) AS total_begin_checkout,
  SUM(added_shipping_info) AS total_add_shipping_info,
  SUM(added_payment_info) AS total_add_payment_info,
  SUM(purchased) AS total_purchases,
  ROUND(SAFE_DIVIDE(SUM(added_to_cart), SUM(viewed)) * 100, 2) AS view_to_cart_rate_pct,
  ROUND(SAFE_DIVIDE(SUM(began_checkout), SUM(added_to_cart)) * 100, 2) AS cart_to_checkout_rate_pct,
  ROUND(SAFE_DIVIDE(SUM(added_shipping_info), SUM(began_checkout)) * 100, 2) AS checkout_to_shipping_rate_pct,
  ROUND(SAFE_DIVIDE(SUM(added_payment_info), SUM(added_shipping_info)) * 100, 2) AS shipping_to_payment_rate_pct,
  ROUND(SAFE_DIVIDE(SUM(purchased), SUM(added_payment_info)) * 100, 2) AS payment_to_purchase_rate_pct,
  ROUND(SAFE_DIVIDE(SUM(purchased), SUM(viewed)) * 100, 2) AS overall_conversion_rate_pct
FROM device_funnel
GROUP BY 1
ORDER BY total_views DESC;