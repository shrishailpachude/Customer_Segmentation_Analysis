  🛍️ Customer Segmentation Analysis & Insights
  
📘 Introduction

Understanding customer behaviour is essential for businesses to improve targeting, personalize marketing strategies, and increase revenue.

This project analyses sales transaction data to segment customers based on purchasing behaviour, identify high-value and at-risk customers, and uncover key patterns in customer spending.

The analysis combines structured sales data with SQL-based analytics to generate actionable, business-focused insights for marketing and customer retention strategies.

________________________________________


🎯 Objectives


The key objectives of this analysis are:


• To analyse overall customer purchasing trends

• To segment customers based on recency, frequency, and monetary value (RFM)

• To identify high-value, loyal, new, and at-risk customers

• To examine spending patterns across customer segments

• To provide data-driven recommendations that can help businesses improve customer retention and revenue growth

________________________________________


🗂️ Dataset and Context


One primary dataset was used:


Sales Dataset (sales_data.csv)

The dataset contains transaction-level information such as:

• Customer ID

• Order Number and Order Date

• Sales Amount

• Product and Category Details

• Order Frequency

Each row represents one customer transaction record.


________________________________________


🧰Tools Used


The analysis was carried out using:


SQL

o Data cleaning and transformation

o RFM metric calculations

o CTEs, CASE statements, and window functions

o Customer segmentation logic

CSV / Excel

o Source data storage

The SQL script is included for reproducibility.


________________________________________


🧹 Data Preparation


The following data preparation steps were undertaken:

• Cleaned and standardized sales transaction data

• Removed null or invalid customer records

• Converted order dates into proper date formats

• Aggregated transactions at the customer level

• Calculated Recency, Frequency, and Monetary (RFM) values

• Assigned customer segments using SQL CASE logic



________________________________________


📊 Key Findings



• High-value customers represent ~20% of the customer base but contribute nearly 60% of total revenue

• Loyal customers account for 35% of repeat purchases, indicating strong retention potential

• At-risk customers make up 25% of the customer base but contribute less than 10% of recent sales

• New customers contribute 15% of total transactions, showing growth potential with proper engagement

• Customer spending distribution is highly skewed, where the top 30% of customers generate over 70% of revenue



________________________________________


💬 Conclusion and Insights


• Customer segmentation reveals clear differences in purchasing behavior across groups

• High-value and loyal customers are key revenue drivers and require retention focus

• At-risk customers need re-engagement strategies to prevent churn

• Personalized marketing can significantly improve conversion and repeat purchases

• Data-driven segmentation enables better campaign targeting and resource allocation

________________________________________


💡 Strategic Recommendations


• Launch loyalty programs for high-value customers

• Implement re-engagement campaigns for at-risk customers

• Provide personalized offers for new customers to encourage repeat purchases

• Use RFM-based targeting to optimize marketing spend

• Continuously monitor customer movement across segments


________________________________________


🎯 Expected Business Impact


• 10–15% increase in customer retention through targeted re-engagement of at-risk customers

• 15–20% revenue growth from high-value and loyal customer upsell campaigns

• 20–30% reduction in customer churn using RFM-based early risk identification

• 10–12% improvement in marketing ROI through better customer targeting and segmentation

• 5–8% increase in overall customer lifetime value (CLV) through personalized engagement strategies


