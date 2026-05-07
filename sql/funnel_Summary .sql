WITH funnel AS (
  SELECT
    user_pseudo_id,
    -- Convert BOOL → INT64 so SUM() works
    CAST(MAX(event_name = 'view_item') AS INT64) AS viewed,
    CAST(MAX(event_name = 'add_to_cart') AS INT64) AS added_to_cart,
    CAST(MAX(event_name = 'begin_checkout') AS INT64) AS began_checkout,
    CAST(MAX(event_name = 'add_shipping_info') AS INT64) AS added_shipping_info,
    CAST(MAX(event_name = 'add_payment_info') AS INT64) AS added_payment_info,
    CAST(MAX(event_name = 'purchase') AS INT64) AS purchased
  FROM `funnel-analysis-478313.analysis.funnel_analysis_dataset`
  GROUP BY user_pseudo_id
)
SELECT
  SUM(viewed)               AS product_views,
  SUM(added_to_cart)        AS add_to_cart,
  SUM(began_checkout)       AS begin_checkout,
  SUM(added_shipping_info)  AS add_shipping_info,
  SUM(added_payment_info)   AS add_payment_info,
  SUM(purchased)            AS purchases
FROM funnel;
