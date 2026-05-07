WITH monthly_events AS (
  SELECT
    user_pseudo_id,
    FORMAT_DATE('%Y-%m', DATE(PARSE_DATE('%Y%m%d', event_date))) AS month,
    event_name
  FROM `funnel-analysis-478313.analysis.funnel_analysis_dataset`
),

funnel AS (
  SELECT
    user_pseudo_id,
    month,
    CAST(MAX(event_name = 'view_item') AS INT64) AS viewed,
    CAST(MAX(event_name = 'add_to_cart') AS INT64) AS added,
    CAST(MAX(event_name = 'begin_checkout') AS INT64) AS checkout,
    CAST(MAX(event_name = 'add_shipping_info') AS INT64) AS shipping,
    CAST(MAX(event_name = 'add_payment_info') AS INT64) AS payment,
    CAST(MAX(event_name = 'purchase') AS INT64) AS purchased
  FROM monthly_events
  GROUP BY user_pseudo_id, month
)

SELECT
  month,
  SUM(viewed) AS product_views,
  SUM(added) AS add_to_cart,
  SUM(checkout) AS begin_checkout,
  SUM(shipping) AS add_shipping_info,
  SUM(payment) AS add_payment_info,
  SUM(purchased) AS purchases
FROM funnel
GROUP BY month
ORDER BY month;
