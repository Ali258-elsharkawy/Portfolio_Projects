-- ============================================
-- DataCo Supply Chain Analysis
-- Script: loading_data
-- Purpose: loading data into dimension and fact tables 
--          from the main table with the clean time interval (2015-01-01 to 2017-9-30)       
-- Date: May 2026
-- ============================================




--===============================================================================
--                      LOADING COLUMNS INTO DIM TABLES 
--===============================================================================


-- =============================================
-- Loading data into dim_date
-- =============================================

-- Generate all dates in real data range
WITH date_series AS (
    SELECT CAST('2015-01-01' AS DATE) AS full_date
    UNION ALL
    SELECT DATEADD(DAY, 1, full_date)
    FROM date_series
    WHERE full_date < '2017-10-01'  -- real data cutoff (excluding ~ 8400 row of bad quality data)
)
INSERT INTO dim_date (
    full_date, year, quarter, month, month_name,
    week, day, day_name, is_weekend, year_month
)
SELECT
    full_date,
    YEAR(full_date),
    DATEPART(QUARTER, full_date),
    MONTH(full_date),
    DATENAME(MONTH, full_date),
    DATEPART(WEEK, full_date),
    DAY(full_date),
    DATENAME(WEEKDAY, full_date),
    CASE WHEN DATEPART(WEEKDAY, full_date) IN (1,7) THEN 1 ELSE 0 END,
    FORMAT(full_date, 'yyyy-MM')
FROM date_series
OPTION (MAXRECURSION 10000);

-- =============================================
-- Loading data into dim_customer
-- =============================================

INSERT INTO dim_customer (customer_id, first_name, last_name, 
            customer_segment, customer_city,customer_state,
            customer_country,customer_street,customer_zipcode)
SELECT DISTINCT
    [Customer Id], [Customer Fname], [Customer Lname],
    [Customer Segment],[Customer City],[Customer State],
    [Customer Country], [Customer Street],[Customer Zipcode]
FROM dataco_clean

-- =============================================
-- Loading data into dim_product
-- =============================================

INSERT INTO dim_product (product_card_id, product_name, category_id,
                        category_name, department_id,department_name,
                        product_price,launch_year,launch_date,cohort_label)
SELECT DISTINCT
    [Product Card Id],[Product Name], [Category Id],
    [Category Name],[Department Id], [Department Name],
    [Product Price],launch_year ,MIN(order_date_clean), cohort_label
FROM dataco_clean

-- =============================================
-- Loading data into dim_shipping
-- =============================================

INSERT INTO dim_shipping (shipping_mode)
SELECT DISTINCT
    [Shipping Mode]
FROM dataco_clean

--===============================================================================
--                      LOADING COLUMNS INTO FACT TABLE 
--===============================================================================


INSERT INTO fact_orders (
    order_item_id, order_id,
    customer_key, product_key,
    date_key, shipping_mode_key,
    time_key, 
    order_city, order_state, order_country,
    order_region, market, state_segment,payment_method,
    latitude, longitude,
    sales, product_profit,
    order_item_quantity,
    order_item_discount, order_item_discount_rate,
    order_item_profit_ratio,
    days_shipping_scheduled, days_shipping_actual,
    days_of_delay, severity_score,
    is_late, non_revenue_flag,
    profit_segment, order_status
)
SELECT
    f.[Order Item Id],
    f.[Order Id],
    c.customer_key,
    p.product_key,
    d.date_key,
    s.shipping_mode_key,
    t.time_key, 
    f.[Order City],
    f.[Order State],
    f.[Order Country],
    f.[order region],
    f.[Market],
    f.[State_Segment],
    f.Type,
    CAST(f.[Latitude] AS FLOAT),
    CAST(f.[Longitude] AS FLOAT),
    CAST(f.[Sales] AS FLOAT),
    CAST(f.[Order Profit Per Order] AS FLOAT),
    CAST(f.[Order Item Quantity] AS INT),
    CAST(f.[Order Item Discount] AS FLOAT),
    CAST(f.[Order Item Discount Rate] AS FLOAT),
    CAST(f.[Order Item Profit Ratio] AS FLOAT),
    CAST(f.[Days for shipment (scheduled)] AS INT),
    CAST(f.[Days for shipping (real)] AS INT),
    CAST(f.[Delay Time (Days)] AS INT),
    CAST(f.[Custom Severity Score] AS FLOAT),
    CAST(f.Late_delivery_indicator AS tinyint),
    f.non_revenue_flag,
    f.[profit_segment],
    f.[Order Status]
FROM dataco_clean f
JOIN dim_customer c ON c.customer_id = f.[Customer Id]
JOIN dim_product  p ON p.product_card_id = f.[Product Card Id]
JOIN dim_shipping s ON s.shipping_mode = f.[Shipping Mode]
JOIN dim_date     d ON d.full_date = f.order_date_clean
-- Join on the HOUR of the original raw datetime column
JOIN dim_time     t ON t.time_key = DATEPART(HOUR, f.[order date (DateOrders)])
WHERE f.order_date_clean >= '2015-01-01' 
  AND f.order_date_clean < '2017-10-01';
