WITH funnel AS (
  SELECT
    user_pseudo_id,
    CAST(MAX(event_name = 'view_item') AS INT64) AS viewed,
    CAST(MAX(event_name = 'add_to_cart') AS INT64) AS added,
    CAST(MAX(event_name = 'begin_checkout') AS INT64) AS checkout,
    CAST(MAX(event_name = 'add_shipping_info') AS INT64) AS shipping,
    CAST(MAX(event_name = 'add_payment_info') AS INT64) AS payment,
    CAST(MAX(event_name = 'purchase') AS INT64) AS purchased
  FROM `funnel-analysis-478313.analysis.funnel_analysis_dataset`
  GROUP BY user_pseudo_id
),

counts AS (
  SELECT
    SUM(viewed) AS views,
    SUM(added) AS carts,
    SUM(checkout) AS checkouts,
    SUM(shipping) AS shipping_info,
    SUM(payment) AS payment_info,
    SUM(purchased) AS purchases
  FROM funnel
)

SELECT
  ROUND(carts / views * 100, 2) AS view_to_cart_rate,
  ROUND(checkouts / carts * 100, 2) AS cart_to_checkout_rate,
  ROUND(shipping_info / checkouts * 100, 2) AS checkout_to_shipping_rate,
  ROUND(payment_info / shipping_info * 100, 2) AS shipping_to_payment_rate,
  ROUND(purchases / payment_info * 100, 2) AS payment_to_purchase_rate,
  ROUND(purchases / views * 100, 2) AS overall_conversion_rate
FROM counts;
