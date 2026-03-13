
-- 1.New column discount with numeric datatype

ALTER TABLE sales ADD COLUMN discount NUMERIC(5,2) 

UPDATE sales
SET discount =
    CASE
        WHEN discount_percent ~ '^[0-9]+$'
        THEN discount_percent::NUMERIC
        ELSE 0
    END;
	
-- 2.Delete the old discount_percent column

ALTER TABLE SALES 
DROP COLUMN discount_percent ;

-- 3.Full transaction view
SELECT 
    s.transaction_id,
    s.sale_date,
	
    c.customer_id,
    c.customer_name,
    c.age,
    c.city,

    p.product_id,
    p.product_name,
    p.category,
    p.price,

    st.store_id,
    st.store_city,
    st.store_type,

    s.quantity,

	(p.price*s.quantity) AS Gross_Amount,
	ROUND((p.price*s.quantity*(1-s.discount/100.0)),2) AS Net_Sales_Amount

FROM sales s JOIN customers c ON s.customer_id=c.customer_id
JOIN products p ON s.product_id=p.product_id
JOIN stores st ON s.store_id=st.store_id;
	
-- 4. Total revenue
SELECT 
SUM(p.price*s.quantity) AS Total_revenue
FROM products p 
JOIN sales s 
ON p.product_id=s.product_id;

-- 5.Total revenue by month
SELECT 
DATE_TRUNC('month',sale_date) AS month,
SUM(s.quantity*p.price) AS Total_revenue_by_month
FROM sales s
JOIN products p
ON s.product_id=p.product_id
GROUP BY month
ORDER BY month;

-- 6.Revenue by product category
SELECT
  p.category,
  SUM(s.quantity * p.price) AS revenue
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY p.category
ORDER BY revenue DESC;

--7. Top 10 customers by revenue

SELECT c.customer_name,
SUM(s.quantity * p.price) AS total_spent
FROM sales s
JOIN customers c ON s.customer_id=c.customer_id
JOIN products p ON s.product_id=p.product_id
GROUP BY c.customer_name
ORDER BY total_spent DESC
LIMIT 10;

-- 8.Customer purchase frequency

SELECT customer_id,
COUNT(transaction_id) AS frequency
FROM sales  
GROUP BY customer_id 
ORDER BY frequency DESC;

-- 9.Average order value (AOV)

SELECT ROUND(SUM(s.quantity*p.price)/ COUNT(DISTINCT(s.transaction_id))) AS Average_order_value
FROM sales s
JOIN products p
ON s.product_id=p.product_id;

-- 10.Average order value (AOV)

SELECT ROUND(SUM(s.quantity*p.price)/ COUNT(DISTINCT(s.transaction_id))) AS Average_order_value
FROM sales s
JOIN products p
ON s.product_id=p.product_id;

-- 11. Revenue by store city

SELECT st.store_city,SUM(s.quantity*p.price) AS revenue_by_city
FROM sales s
JOIN stores st ON st.store_id=s.store_id
JOIN products p ON s.product_id=p.product_id
GROUP BY st.store_city;

-- 12.Store type comparison

SELECT st.store_type,COUNT(DISTINCT(s.transaction_id)) AS total_transactions,
SUM(s.quantity*p.price) AS revenue
FROM Sales s
JOIN stores st ON st.store_id=s.store_id
JOIN products p ON s.product_id=p.product_id
GROUP BY store_type
ORDER BY revenue DESC;

-- 13.Revenue after discount

SELECT 
ROUND(SUM(s.quantity*p.price*(1-s.discount/100)),2) AS revenue_after_discount
FROM sales s 
JOIN products p 
ON s.product_id=p.product_id;

-- 14.High discount impact products

SELECT p.product_name,AVG(s.discount) AS avg_discount
FROM products p 
JOIN sales s 
ON p.product_id=s.product_id
GROUP BY p.product_name
ORDER BY avg_discount DESC;

-- 15.Sales by weekday

SELECT TO_CHAR(sale_date,'Day') AS weekday,
COUNT(*)AS transactions
FROM Sales 
GROUP BY weekday;

-- 16.Customer contribution by type(new vs old)

SELECT 
CASE 
WHEN s.sale_date-c.signup_date<=90 THEN 'new_customer'
ELSE 'old customer'
END AS customer_type,
SUM(s.quantity*p.price)AS revenue
FROM sales s 
JOIN customers c ON s.customer_id=c.customer_id
JOIN products p ON s.product_id=p.product_id
GROUP BY customer_type;

-- 17. Running total revenue(window function)

SELECT
  sale_date,
  SUM(quantity * price) OVER (ORDER BY sale_date) AS running_revenue
FROM sales s
JOIN products p ON s.product_id = p.product_id;

-- 18.Rank products by revenue

SELECT
  p.product_name,
  SUM(s.quantity * p.price) AS revenue,
  RANK() OVER (ORDER BY SUM(s.quantity * p.price) DESC) AS revenue_rank
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY p.product_name;

-- 19.Customer Lifetime Value (CLV)

SELECT
  c.customer_id,
  c.customer_name,
  ROUND(SUM(s.quantity * p.price * (1 - s.discount/100.0)),2) AS lifetime_value
FROM sales s
JOIN customers c ON s.customer_id = c.customer_id
JOIN products p ON s.product_id = p.product_id
GROUP BY c.customer_id, c.customer_name
ORDER BY lifetime_value DESC;

-- 20.RFM Segmentation 

WITH rfm AS (
  SELECT
    c.customer_id,
    MAX(s.sale_date) AS last_purchase,
    COUNT(DISTINCT s.transaction_id) AS frequency,
    SUM(s.quantity * p.price) AS monetary
  FROM sales s
  JOIN customers c ON s.customer_id = c.customer_id
  JOIN products p ON s.product_id = p.product_id
  GROUP BY c.customer_id
)
SELECT *,
  CASE
    WHEN frequency >= 10 AND monetary > 50000 THEN 'High Value'
    WHEN frequency >= 5 THEN 'Medium Value'
    ELSE 'Low Value'
  END AS customer_segment
FROM rfm;

-- 21.Discount impact analysis

SELECT
  CASE
    WHEN discount = 0 THEN 'No Discount'
    WHEN discount BETWEEN 1 AND 10 THEN 'Low Discount'
    ELSE 'High Discount'
  END AS discount_bucket,
  SUM(quantity * price) AS revenue
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY discount_bucket;

-- 22.Repeat vs one-time customers

SELECT
  CASE
    WHEN COUNT(transaction_id) = 1 THEN 'One-time'
    ELSE 'Repeat'
  END AS customer_type,
  COUNT(*) AS customers
FROM sales
GROUP BY customer_id;

-- 23.Month-over-month growth

WITH monthly AS (
  SELECT
    DATE_TRUNC('month', sale_date) AS month,
    SUM(quantity * price) AS revenue
  FROM sales s
  JOIN products p ON s.product_id = p.product_id
  GROUP BY month
)
SELECT
  month,
  revenue,
  revenue - LAG(revenue) OVER (ORDER BY month) AS mom_growth
FROM monthly;

