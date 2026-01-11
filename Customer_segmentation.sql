                                           -- Data Cleaning
-- Created database
Create database marketing;

-- Created a copy of raw_data
create table sales
(select * from sales_raw);

-- Checking Duplicates
with cte as 
(select *,row_number() over(partition by order_number,quantity_ordered,price,sales 
    order by order_number) as rn
from sales
order by order_number)

select *
from cte 
where rn > 1; -- No duplicates found

-- Handling Null and missing values
-- State
update sales
set state = 'Unknown'
where state = '';

-- Postal Code
update sales
set POSTAL_CODE = null
where POSTAL_CODE = '';

-- Handling Inconsistent date format
update sales
set order_date = date_format(str_to_date(order_date,'%m/%d/%Y'),'%Y/%m/%d');

-- Changed Data types
alter table sales
modify ORDER_NUMBER int, 
modify QUANTITY_ORDERED int, 
modify PRICE decimal(10,2) ,
modify ORDER_LINE_NUMBER int ,
modify SALES decimal(10,2) ,
modify ORDER_DATE date ,
modify `STATUS` varchar(50), 
modify QTR_ID int, 
modify PRODUCT_LINE varchar(50) ,
modify MSRP int, 
modify PRODUCT_CODE varchar(50), 
modify CUSTOMER_NAME varchar(100), 
modify PHONE varchar(50), 
modify ADDRESS_LINE1 text, 
modify CITY varchar(50), 
modify STATE varchar(50), 
modify POSTAL_CODE varchar(50) ,
modify COUNTRY varchar(50), 
modify CONTACT_LAST_NAME varchar(50), 
modify CONTACT_FIRST_NAME varchar(50), 
modify DEAL_SIZE varchar(50);

                                                -- Data Analysis

-- How can we segment customers using RFM (Recency, Frequency, Monetary)?
-- Identify high-value, loyal, at-risk, and new customers.
with orders as 
(select customer_name,
 max(order_date) as last_order_date,
 (select max(order_date) from sales) as Last_sale,
count(distinct order_number) as Frequency,
  sum(sales) as Monetary
from sales
group by customer_name),

rfm as
(select customer_name,datediff(last_sale,last_order_date) as Recency_days,
 frequency,monetary
 from orders),
 
 rfm_score as 
 (select customer_name,
 ntile(4) over(order by recency_days desc) as r_score,
  ntile(4) over(order by frequency) as f_score,
   ntile(4) over(order by monetary) as m_score
from rfm)

select customer_name,r_score,f_score,m_score,
 concat(r_score,f_score,m_score) as rfm_segment
from rfm_score
order by rfm_segment desc;

-- Who are our top 20% customers contributing to 80% of revenue?
with customer_sales as
(select customer_name,sum(sales) as Total_sales
from sales
group by customer_name),

ranked_customers as
(select customer_name,total_sales,
(sum(total_sales) over(order by total_sales desc)/
sum(total_sales) over()) as cumulative_sales_pct
from customer_sales)

select customer_name,total_sales,cumulative_sales_pct
from ranked_customers
where cumulative_sales_pct <= 0.8;

-- Which customers are high-value but at risk of churn?
with customer_orders as
(select customer_name,sum(sales) as total_sales,
 count(distinct order_number) as frequency,
  max(order_date) as last_purchase_date,
  (select max(order_date) from sales) as last_sales
from sales
group by customer_name)

select customer_name,total_sales,frequency,
  datediff(last_sales,last_purchase_date) as recency_days
from customer_orders
where total_sales > (select avg(sales) from sales)
 and datediff(last_sales,last_purchase_date) > 90
order by total_sales desc;

-- Segment customers by purchase behavior (Low, Medium, High frequency
with customers as
(select customer_name,count(distinct order_number) as total_orders
from sales
group by customer_name)

select customer_name,total_orders,
case when total_orders <= 2 then 'Low'
     when total_orders between 3 and 9 then 'Medium'
     else 'High' end as Customer_order_frequency
from customers
group by customer_name
order by total_orders desc;

-- Which customer segments generate the highest average order value?
with customer_order_value as 
(select customer_name,sum(sales)/count(distinct order_number) as avg_order_value
from sales
group by customer_name)

select 
case when avg_order_value <= 5000 then 'Low Value'
     when avg_order_value between 6000 and 10000 then 'Medium Value'
      else 'High Value' end as Customer_segment,
        count(customer_name) as Total_customers,
        round(avg(avg_order_value),2) as avg_segment_aov
from customer_order_value
group by Customer_segment
order by avg_segment_aov desc;

-- Identify customers with declining purchase trends
with yearly_sales as
(select customer_name,year(order_date) as sales_year,sum(sales) as current_year_sale,
   lag(sum(sales)) over(partition by customer_name order by year(order_date)) as last_year_sale
from sales
group by customer_name,sales_year)

select customer_name,sales_year,last_year_sale,current_year_sale
from yearly_sales
where current_year_sale < last_year_sale
 and last_year_sale is not null;

-- Identify customers buying across multiple product categories.
select customer_name,count(distinct product_line) as products_purchased
from sales
group by customer_name
having products_purchased >= 3 ;

-- Segment customers based on lifecycle stage (New, Active, Loyal)
with customer_lifecycle as
(select customer_name,min(order_date) as first_purchase_date,
  max(order_date) as last_purchase_date,
  count(distinct order_number) as Total_orders
from sales
group by customer_name)

select customer_name,total_orders,
case when total_orders = 1 then 'New'
     when total_orders between 2 and 5 then 'Active '
        else 'Loyal' end as Lifecycle_stage
from customer_lifecycle
order by total_orders desc;

-- Which customer segments are most sensitive to discounts?
select customer_name,round(avg(price),2) as avg_price,
  round(avg(sales/quantity_ordered),2) as effective_unit_price
from sales
group by customer_name
having avg_price < (select avg(price) 
					from sales);

-- Which customer segments show early churn risk based on declining order frequency?
with yearly_orders as
(select customer_name,year(order_date) as `Year`,
  count(distinct order_number) as total_orders
from sales
group by customer_name,`Year`),

previous_orders as 
(select customer_name,year,total_orders as current_year_orders,
  lag(total_orders) over(partition by customer_name order by `year`) as previous_year_orders
from yearly_orders)

select customer_name,year,previous_year_orders,current_year_orders,
 (previous_year_orders-current_year_orders) as orders_declined
from previous_orders
where previous_year_orders is not null
 and current_year_orders < previous_year_orders
order by orders_declined desc;

-- Which customer segments have high lifetime value but low product diversity (cross-sell opportunity)?
with customer_value as 
(select customer_name,sum(sales) as lifetime_value,
 count(distinct product_line) as products_purchased
from sales
group by customer_name)

select customer_name,lifetime_value,products_purchased
from customer_value
where lifetime_value > (select avg(lifetime_value) from customer_value)
  and products_purchased <= 3
order by lifetime_value desc;

-- Build a final customer segmentation table
create view customer_segmentation as
(select customer_name,count(distinct order_number) as Total_orders,
  sum(sales) as Lifetime_sales,
  count(distinct product_line) as product_diversity,
  max(order_date) last_ordered_date
 from sales
 group by customer_name);






