CREATE DATABASE business_kpi_dashboard;

USE business_kpi_dashboard;

CREATE TABLE sales_transactions (
    sales_id INT PRIMARY KEY,
    order_date DATE,
    customer_id INT,
    product_id INT,
    region_id INT,
    quantity INT,
    unit_price DECIMAL(10,2),
    sales_amount DECIMAL(12,2),
    channel VARCHAR(20)
);

CREATE TABLE returns_transactions (
    return_id INT PRIMARY KEY,
    sales_id INT,
    return_date DATE,
    return_amount DECIMAL(12,2),
    return_reason VARCHAR(50)
);

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    segment VARCHAR(50),
    signup_date DATE
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    cost_price DECIMAL(10,2)
);

CREATE TABLE regions (
    region_id INT PRIMARY KEY,
    region_name VARCHAR(50),
    region_manager VARCHAR(100)
);

SELECT COUNT(*) FROM sales_transactions;

SELECT 
    r.region_name,
    COUNT(s.sales_id) AS total_orders,
    SUM(s.sales_amount) AS total_sales
FROM sales_transactions s
JOIN regions r
    ON s.region_id = r.region_id
GROUP BY r.region_name
ORDER BY total_sales DESC;

SELECT
    r.region_name,
    SUM(s.sales_amount) AS total_sales,
    IFNULL(SUM(rt.return_amount), 0) AS total_returns,
    SUM(s.sales_amount) - IFNULL(SUM(rt.return_amount), 0) AS net_revenue
FROM sales_transactions s
LEFT JOIN returns_transactions rt
    ON s.sales_id = rt.sales_id
JOIN regions r
    ON s.region_id = r.region_id
GROUP BY r.region_name
ORDER BY net_revenue DESC;

SELECT
    r.region_name,
    SUM(s.sales_amount) AS total_sales,
    IFNULL(SUM(rt.return_amount), 0) AS total_returns,
    ROUND(
        (IFNULL(SUM(rt.return_amount), 0) / SUM(s.sales_amount)) * 100,
        2
    ) AS return_rate_pct
FROM sales_transactions s
LEFT JOIN returns_transactions rt
    ON s.sales_id = rt.sales_id
JOIN regions r
    ON s.region_id = r.region_id
GROUP BY r.region_name
ORDER BY return_rate_pct DESC;

SELECT
    r.region_name,
    SUM(s.sales_amount) - IFNULL(SUM(rt.return_amount), 0) AS net_revenue
FROM sales_transactions s
LEFT JOIN returns_transactions rt
    ON s.sales_id = rt.sales_id
JOIN regions r
    ON s.region_id = r.region_id
GROUP BY r.region_name
ORDER BY net_revenue DESC;

WITH region_net_revenue AS (
    SELECT
        r.region_name,
        SUM(s.sales_amount) - IFNULL(SUM(rt.return_amount), 0) AS net_revenue
    FROM sales_transactions s
    LEFT JOIN returns_transactions rt
        ON s.sales_id = rt.sales_id
    JOIN regions r
        ON s.region_id = r.region_id
    GROUP BY r.region_name
)

WITH region_net_revenue AS (
    SELECT
        r.region_name,
        SUM(s.sales_amount) - IFNULL(SUM(rt.return_amount), 0) AS net_revenue
    FROM sales_transactions s
    LEFT JOIN returns_transactions rt
        ON s.sales_id = rt.sales_id
    JOIN regions r
        ON s.region_id = r.region_id
    GROUP BY r.region_name
)
SELECT
    MAX(net_revenue) AS top_region_net_revenue,
    MIN(net_revenue) AS bottom_region_net_revenue,
    ROUND(
        (MAX(net_revenue) - MIN(net_revenue)) / MAX(net_revenue) * 100,
        2
    ) AS performance_gap_pct
FROM region_net_revenue;










SELECT
    r.region_name,
    ROUND(
        (IFNULL(SUM(rt.return_amount), 0) / SUM(s.sales_amount)) * 100,
        2
    ) AS return_rate_pct
FROM sales_transactions s
LEFT JOIN returns_transactions rt
    ON s.sales_id = rt.sales_id
JOIN regions r
    ON s.region_id = r.region_id
GROUP BY r.region_name;
