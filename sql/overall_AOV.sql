-- AOV = Total Revenue / Number of Orders


SELECT
  -- SUM(revenue_usd) AS total_revenue,
  COUNT(*) AS number_of_orders,
  ROUND(SUM(revenue_usd) / COUNT(*), 2) AS AOV_USD
FROM `funnel-analysis-478313.analysis.funnel_analysis_dataset`
WHERE event_name = 'purchase';
