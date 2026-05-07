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
),

monthly_counts AS (
  SELECT
    month,
    SUM(viewed) AS views,
    SUM(added) AS carts,
    SUM(checkout) AS checkouts,
    SUM(shipping) AS shipping_info,
    SUM(payment) AS payment_info,
    SUM(purchased) AS purchases
  FROM funnel
  GROUP BY month
)

SELECT
  month,
  ROUND(carts / views * 100, 2)           AS view_to_cart_rate,       -- V→C
  ROUND(checkouts / carts * 100, 2)       AS cart_to_checkout_rate,   -- C→CO
  ROUND(shipping_info / checkouts * 100, 2) AS checkout_to_shipping_rate, -- CO→S
  ROUND(payment_info / shipping_info * 100, 2) AS shipping_to_payment_rate, -- S→P
  ROUND(purchases / payment_info * 100, 2) AS payment_to_purchase_rate,    -- P→Purchase
  ROUND(purchases / views * 100, 2)       AS overall_conversion_rate  -- Overall
FROM monthly_counts
ORDER BY month;
