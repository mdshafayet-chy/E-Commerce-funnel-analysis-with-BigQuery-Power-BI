WITH user_journey AS (
  SELECT
    user_pseudo_id,
    MIN(CASE WHEN event_name = 'view_item' THEN event_timestamp END) AS first_view_ts,
    MIN(CASE WHEN event_name = 'purchase' THEN event_timestamp END) AS first_purchase_ts
  FROM `funnel-analysis-478313.analysis.funnel_analysis_dataset`
  GROUP BY 1
),
valid_journey AS (
  SELECT
    user_pseudo_id,
    TIMESTAMP_MICROS(first_view_ts) AS first_view_time,
    TIMESTAMP_MICROS(first_purchase_ts) AS first_purchase_time,
    TIMESTAMP_DIFF(
      TIMESTAMP_MICROS(first_purchase_ts),
      TIMESTAMP_MICROS(first_view_ts),
      MINUTE
    ) AS minutes_to_purchase
  FROM user_journey
  WHERE first_view_ts IS NOT NULL
    AND first_purchase_ts IS NOT NULL
    AND first_purchase_ts >= first_view_ts
)
SELECT
  user_pseudo_id,
  first_view_time,
  first_purchase_time,
  minutes_to_purchase,
  ROUND(minutes_to_purchase / 60.0, 2) AS hours_to_purchase,
  ROUND(minutes_to_purchase / 1440.0, 2) AS days_to_purchase
FROM valid_journey
ORDER BY minutes_to_purchase;