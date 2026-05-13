# marketing_analysis

## Project Objective
The primary goal of this project is to evaluate the effectiveness of various marketing channels (Google, Meta, TikTok) by calculating key performance indicators (KPIs) and Unit Economics metrics. 

## Dataset Used
The analysis is based on two primary tables within the Google BigQuery environment:  
marketing_ads_raw: Contains raw performance data including spend, impressions, clicks, installs, and registrations for each ad banner.  
workshop_data: Provides the Lifetime Value (LTV) metrics and detailed conversion benchmarks for users acquired through different channels. 

## Key Questions
For our analysis, we selected several key areas:  
- Which marketing channel has the lowest Customer Acquisition Cost (CAC)?
- At which stage of the funnel do we observe the highest user drop-off?
- Is Meta's higher spending justified by its performance metrics compared to Google and TikTok?

## Process
The work was divided into the following technical processing stages:

1. Data Cleaning: Handled cumulative data by using window functions (ROW_NUMBER) to extract only the latest snapshot for each unique ad_id to prevent double-counting metrics.

2. Metric Calculation: Aggregated data to calculate CPM, CTR and conversion rates (Click-to-Install and Install-to-Registration).

3. Unit Economics Integration: Joined marketing data with the LTV dataset using a LEFT JOIN on the channel source.

4. Profitability Analysis: Calculated the final CAC and LTV/CAC ratios for each source.

The final results were formatted as follows:
<img width="1489" height="131" alt="Знімок екрана 2026-05-13 162414" src="https://github.com/user-attachments/assets/80504437-538e-4fa3-b722-87239132b794" />


## Project Insights
Efficiency Leader: Meta demonstrates the best efficiency with the lowest CAC ($3.10) and the highest LTV/CAC (24.93), making it the most profitable channel despite having the highest total spend.

Funnel Weakness: The biggest drop-off occurs at the Click-to-Install stage, where conversion rates stay between 30-40%, whereas the Install-to-Registration stage is highly efficient (>85%).

Unprofitable Growth: Google is currently unprofitable with an LTV/CAC of 6.56, meaning the cost to acquire a user ($14.11) exceeds the revenue they generate ($12.40).

## Final Conclusion

The current marketing strategy should prioritize further scaling of Meta as it successfully maintains low acquisition costs at high volumes. TikTok remains a viable secondary channel while the Google strategy requires immediate optimization of targeting or creative assets to lower the CAC.
