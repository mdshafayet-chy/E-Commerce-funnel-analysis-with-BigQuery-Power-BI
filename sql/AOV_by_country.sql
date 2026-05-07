-- -- AOV = Total Revenue / Number of Orders

SELECT
  country,
  ROUND(SUM(revenue_usd), 2) AS total_revenue,
  COUNT(*) AS number_of_orders,
  ROUND(SUM(revenue_usd) / COUNT(*), 2) AS aov_usd
FROM `funnel-analysis-478313.analysis.funnel_analysis_dataset`
WHERE event_name = 'purchase'
GROUP BY country
ORDER BY  aov_usd DESC;





