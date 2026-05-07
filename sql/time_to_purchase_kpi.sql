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
  ROUND(AVG(minutes_to_purchase), 2) AS avg_minutes_to_purchase,
  ROUND(AVG(minutes_to_purchase) / 60.0, 2) AS avg_hours_to_purchase,
  ROUND(APPROX_QUANTILES(minutes_to_purchase, 100)[OFFSET(50)], 2) AS median_minutes_to_purchase,
  ROUND(APPROX_QUANTILES(minutes_to_purchase, 100)[OFFSET(50)] / 60.0, 2) AS median_hours_to_purchase
FROM valid_journey;