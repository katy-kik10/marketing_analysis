-- 1. Dedublication
WITH raw_dedub AS (
  SELECT 
    source, 
    ad_id, 
    date, 
    spend, 
    impressions, 
    clicks, 
    installs, 
    registrations,
    -- Assign the number 1 to the last record for each ad_id 
    ROW_NUMBER() OVER(PARTITION BY ad_id ORDER BY timestamp DESC) as latest_snapshot
  FROM `ua-trends-478918.skelar.marketing_ads_raw` 
),
-- 2. Daily metrics
daily_metrics AS (
  SELECT 
    source,
    date,
    SUM(spend) AS daily_spend,
    SUM(impressions) AS daily_impressions,
    SUM(clicks) AS daily_clicks,
    SUM(installs) AS daily_installs,
    SUM(registrations) AS daily_registrations
  FROM raw_dedub
  WHERE latest_snapshot = 1 
  GROUP BY 1, 2
),
-- 3. Channel metrics for the entire period
total_marketing_metrics AS (
  SELECT 
    source,
    -- Total expenses
    SUM(daily_spend) AS total_spend,
    -- CPM (Cost Per Mille) = (Expenses / Screenings) * 1000
    ROUND(SAFE_DIVIDE(SUM(daily_spend), SUM(daily_impressions)) * 1000, 2) AS cpm,    
    -- CTR (Click-Through Rate) = (Clicks / Screenings) * 100%
    ROUND(SAFE_DIVIDE(SUM(daily_clicks), SUM(daily_impressions)) * 100, 2) AS ctr,
    -- CR Click-to-Install = (Installation / Clicks) * 100%
    ROUND(SAFE_DIVIDE(SUM(daily_installs), SUM(daily_clicks)) * 100, 2) AS cr_click_to_install,    
    -- CR Install-to-Reg = (Registrations / Installation) * 100%
    ROUND(SAFE_DIVIDE(SUM(daily_registrations), SUM(daily_installs)) * 100, 2) AS cr_install_to_reg,    
    -- CAC (Cost Per Acquisition) = Expenses / Registrations 
    ROUND(SAFE_DIVIDE(SUM(daily_spend), SUM(daily_registrations)), 2) AS cac
  FROM daily_metrics
  GROUP BY 1
)
-- 4. Combine with the previously calculated LTV, calculate the unit economics and generate the final table
SELECT 
    m.*,
    w.ltv,
    ROUND(SAFE_DIVIDE(w.ltv, m.cac), 2) AS ltv_cac
FROM total_marketing_metrics AS m
LEFT JOIN `ua-trends-478918.skelar.workshop_data` AS w 
    ON m.source = w.channel
ORDER BY source
