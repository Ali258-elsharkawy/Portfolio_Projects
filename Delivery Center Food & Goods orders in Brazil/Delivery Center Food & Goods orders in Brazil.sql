-- creating the database Delivery_Center
CREATE DATABASE Delivery_Center;

--using the database of Delivery_Center
USE Delivery_Center;

-- exploring tables after importaing the data from the csv files using import wizard AND CHECKING FOR NULL VALUES
SELECT*
FROM channels
WHERE channel_id IS NULL; -- No null values found 

SELECT *
FROM deliveries
WHERE delivery_id IS NULL; -- FOUND 4,824 NULL VALUE WHICH UNRELIABLE IN ANALYSING AND RESULT NO NULL VALUES PREVENTING CREATING PRIMARY KEY FOR THIS TABLE. ALSO FOUND EXACT SAME DETAILS FOR DIFFERENT DELIVERY_ID VALUES

-- CREATING MODIFIED 'DELIVERIES' TABLE WHICH IS MORE RELIABLE
DROP TABLE IF EXISTS Modified_deliveries
SELECT *
INTO Modified_deliveries
FROM deliveries;

WITH DuplicateRows AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY delivery_order_Id, driver_id, delivery_distance_meters, delivery_status ORDER BY delivery_id) AS rn -- Used to identify and delete duplicate rows in the subsequent DELETE statement
    FROM Modified_deliveries
)
DELETE FROM DuplicateRows
WHERE rn > 1;

-- Exploring the 'modified_deliveries' table
SELECT TOP 100 *
FROM Modified_deliveries;

 
SELECT*
FROM hubs
WHERE hub_id IS NULL; -- No null values found 

SELECT TOP 100 *
FROM orders
WHERE order_id IS NULL; -- No null values found 

SELECT TOP 100*
FROM payments
WHERE payment_id IS NULL; -- No null values found 


SELECT*
FROM stores
WHERE store_id IS NULL; -- No null values found 

SELECT*
FROM drivers
WHERE driver_id IS NULL; -- No null values found 

-------------------------------------------------------------------------------------------------------------------


-- Setting the primary keys for each table and linking tables

-------------------------------------------------------------------------------------------------------------------


-- Casting channel_id's datatype as INT with non-nullable constraint
ALTER TABLE CHANNELS
ALTER COLUMN CHANNEL_ID INT NOT NULL;

-- Adding primary key for the channels table
ALTER TABLE CHANNELS
ADD PRIMARY KEY (CHANNEL_ID);

-- List all constraints on the table and their types:
EXEC sp_helpconstraint 'CHANNELS';
----------------------------------------------------


-- Adding primary key for the hubs table
ALTER TABLE HUBS
ADD PRIMARY KEY (HUB_ID);

-- Showing the data type of the primary key
SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'HUBS' AND COLUMN_NAME = 'HUB_ID';
----------------------------------------------------


-- Meeting the unnullable constraint required for adding primary key
ALTER TABLE PAYMENTS
ALTER COLUMN PAYMENT_ID INT NOT NULL;

-- Adding primary key for the channels table
ALTER TABLE PAYMENTS
ADD PRIMARY KEY(PAYMENT_ID);

-- Adding foreign key payment_order_id from the payments table, referencing the order_id column in the orders table. This establishes a one-to-many relationship, where each order can have multiple payments, but each payment can only relate to one order.
ALTER TABLE PAYMENTS
ADD FOREIGN KEY (PAYMENT_ORDER_ID) REFERENCES ORDERS (ORDER_ID);
-------------------------------------------------------


-- Adding primary key for the store table.
ALTER TABLE STORES
ALTER COLUMN STORE_ID INT NOT NULL;

-- Adding primary key for the table 'stores'.
ALTER TABLE STORES
ADD PRIMARY KEY (STORE_ID);
-- Adding foreign key to the column 'store_id' in stores table with reference to the column order_id in the orders table. This creates a one-to-many relation, which means every store can have as many orders, but every order can have only one store.
ALTER TABLE STORES 
ADD FOREIGN KEY (HUB_ID) REFERENCES HUBS (HUB_ID)
-------------------------------------------------------


-- Meeting the non-null constraint required for adding a primary key.
ALTER TABLE DRIVERS
ALTER COLUMN DRIVER_ID INT NOT NULL

-- Adding a primary key for the drivers table.
ALTER TABLE DRIVERS
ADD PRIMARY KEY(DRIVER_ID);
-------------------------------------------------------


-- Meeting the non-null constraint required for adding a primary key.
ALTER TABLE MODIFIED_DELIVERIES
ALTER COLUMN DELIVERY_ID INT NOT NULL;

-- Adding a primary key for the Modified_Deliveries table.
ALTER TABLE MODIFIED_DELIVERIES
ADD PRIMARY KEY(DELIVERY_ID);

-- Adding a foreign key 'delivery_order_id' from the Modified_Deliveries table to reference the order_id from the Orders table. This establishes a one-to-many relationship where every order can have multiple deliveries but every delivery can have only one order.
ALTER TABLE MODIFIED_DELIVERIES
ADD FOREIGN KEY (DELIVERY_ORDER_ID) REFERENCES ORDERS (ORDER_ID);

-- Adding a foreign key 'driver_id' from the Modified_Deliveries table to reference the driver_id from the Drivers table. This establishes a one-to-many relationship where every driver can have as many deliveries as needed, but every delivery can have only one driver.
ALTER TABLE MODIFIED_DELIVERIES
ADD FOREIGN KEY (DRIVER_ID) REFERENCES DRIVERS (DRIVER_ID);
-------------------------------------------------------


-- Ensuring the non-null constraint is met for adding the primary key.
ALTER TABLE ORDERS
ALTER COLUMN ORDER_ID INT NOT NULL;


-- Setting the data type for the channel ID to INT.
ALTER TABLE ORDERS
ALTER COLUMN CHANNEL_ID INT NOT NULL;


-- Adding primary key for the Orders table.
ALTER TABLE ORDERS
ADD PRIMARY KEY(ORDER_ID);
-- Adding foreign key 'CHANNEL_ID' from the Orders table referencing the column 'CHANNEL_ID' from Channels table. This creates a many-to-one relation, meaning every channel can have as many orders as it could, but every order can relate to only one channel.
ALTER TABLE ORDERS
ADD FOREIGN KEY (CHANNEL_ID) REFERENCES CHANNELS (CHANNEL_ID);
-- Adding foreign key 'STORE_ID' from the Orders table referencing the column 'STORE_ID' from Stores table. This creates a many-to-one relation, meaning every store can have as many orders as it could, but every order can relate to one store.
ALTER TABLE ORDERS
ADD FOREIGN KEY (STORE_ID) REFERENCES STORES (STORE_ID);
---------------------------------------------------------------------------------------------------------------------------------------------------------------


-- Measuring business performance for each channel
-- Storing the data in views


---------------------------------------------------------------------------------------------------------------------------------------------------------------

DROP VIEW IF EXISTS Channel_status

-- To create a view, it must be the only statement in the batch
-- Place the CREATE VIEW statement between two 'GO' statements to separate it into its own batch
GO;
CREATE VIEW Channel_status AS
SELECT 
	channels.channel_id,
	channel_name,
	ROUND(AVG(payment_amount),2) AVG_REVENUE, --Calculating AVG revenue
	FORMAT(SUM(payment_amount)*1.00,'N') SUM_REVENUE,-- Calculate the total revenue for each channel
	FORMAT(COUNT(DISTINCT order_id),'N') #OF_SALES, -- Counting the number of orders for each channel
	FORMAT(COUNT(DISTINCT order_id)*100.00/(SELECT COUNT(delivery_order_id) FROM orders),'N') "%OF_SALES", -- FOR BETTER UNDERSTANDING, SHOWING the Percentage of contribution of this channel to total sales
	--Calculationg the average and standard deviation for both order cycle time and orderfulfillment time when needed data is available 
	AVG(CASE WHEN order_moment_delivering IS NOT NULL AND order_moment_ready IS NOT NULL THEN DATEDIFF(HOUR, order_moment_created, order_moment_delivering) END) AS 'AVG_Order_cycle_time (H)',
	AVG(CASE WHEN order_moment_ready IS NOT NULL AND order_moment_delivering IS NOT NULL THEN DATEDIFF(HOUR, order_moment_created, order_moment_ready) END) AS 'AVG_Order Fulfillment (H)',
	ROUND(STDEVP(CASE WHEN order_moment_delivering IS NOT NULL AND order_moment_ready IS NOT NULL THEN DATEDIFF(HOUR, order_moment_created, order_moment_delivering) END),2) AS 'STDEVP_Order_cycle_time_in_hours',
	ROUND(STDEVP(CASE WHEN order_moment_ready IS NOT NULL AND order_moment_delivering IS NOT NULL THEN DATEDIFF(HOUR, order_moment_created, order_moment_ready) END),2) AS 'STDEVP_Order Fulfillment Lead Time',
	COUNT(CASE WHEN order_status = 'CANCELED' THEN 1 END) ORDER_CANCELED,
	AVG(delivery_distance_meters) AS average_distance,
	MIN(delivery_distance_meters) AS Min_distance,
	MAX(delivery_distance_meters) AS Max_distance
	
FROM 
	orders
JOIN
	stores ON stores.store_id = orders.store_id
JOIN
	Modified_deliveries on Modified_deliveries.delivery_order_id = orders.delivery_order_id
JOIN 
	channels ON channels.channel_id = orders.channel_id
JOIN 
	payments ON payments.payment_order_id = orders.order_id
GROUP BY 
	channel_name,
	channels.channel_id
GO;

SELECT*
FROM Channel_status
ORDER BY
		CAST(REPLACE(SUM_REVENUE, ',', '') AS FLOAT)
 DESC;

 -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

DROP VIEW IF EXISTS Hub_status;
GO;
 -- Creating the Hub_status view
CREATE VIEW Hub_status AS
SELECT 
	hubs.hub_id,
	hub_name,
	ROUND(AVG(payment_amount),2) AVG_REVENUE, --Calculating AVG revenue
	FORMAT(SUM(payment_amount)*1.00,'N') SUM_REVENUE,-- Calculate the total revenue for each hub 
	FORMAT(COUNT(DISTINCT order_id),'N') #OF_SALES, -- Counting the number of orders for each hub 
	FORMAT(COUNT(DISTINCT order_id)*100.00/(SELECT COUNT(delivery_order_id) FROM orders),'N') "%OF_SALES", -- FOR BETTER UNDERSTANDING, SHOWING the Percentage of contribution of this channel to total sales
	--Calculationg the average and standard deviation for both order cycle time and orderfulfillment time when needed data is available 
	AVG(CASE WHEN order_moment_delivering IS NOT NULL AND order_moment_ready IS NOT NULL THEN DATEDIFF(HOUR, order_moment_created, order_moment_delivering) END) AS 'AVG_Order_cycle_time (H)',
	AVG(CASE WHEN order_moment_ready IS NOT NULL AND order_moment_delivering IS NOT NULL THEN DATEDIFF(HOUR, order_moment_created, order_moment_ready) END) AS 'AVG_Order Fulfillment (H)',
	ROUND(STDEVP(CASE WHEN order_moment_delivering IS NOT NULL AND order_moment_ready IS NOT NULL THEN DATEDIFF(HOUR, order_moment_created, order_moment_delivering) END),2) AS 'STDEVP_Order_cycle_time_in_hours',
	ROUND(STDEVP(CASE WHEN order_moment_ready IS NOT NULL AND order_moment_delivering IS NOT NULL THEN DATEDIFF(HOUR, order_moment_created, order_moment_ready) END),2) AS 'STDEVP_Order Fulfillment Lead Time',
	COUNT(CASE WHEN order_status = 'CANCELED' THEN 1 END) ORDER_CANCELED,
	AVG(delivery_distance_meters) AS average_distance,
	MAX(delivery_distance_meters) AS Max_distance,
	MIN(delivery_distance_meters) AS Min_distance
FROM 
	orders
JOIN
	stores ON stores.store_id = orders.store_id
JOIN 
	hubs ON hubs.hub_id = stores.hub_id
JOIN 
	payments ON payments.payment_order_id = orders.order_id
JOIN
	Modified_deliveries on Modified_deliveries.delivery_order_id = orders.delivery_order_id
GROUP BY 
	hubs.hub_id,
	hub_name
GO;

SELECT *
FROM Hub_status

ORDER BY 
	CAST(REPLACE(SUM_REVENUE, ',','') AS float)
DESC;

 -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
 
 DROP VIEW IF EXISTS Store_status
 GO;
 -- Creating the Store_status view
CREATE VIEW Store_status AS
SELECT 
	stores.store_id,
	store_name,
	ROUND(AVG(DISTINCT payment_amount),2) AVG_REVENUE, --Calculating AVG revenue
	FORMAT(SUM(payments.payment_amount)*1.00,'N') SUM_REVENUE,-- Calculate the total revenue for each store
	FORMAT(COUNT(DISTINCT order_id),'N') #OF_SALES, -- Counting the number of orders 
	FORMAT(COUNT(DISTINCT order_id)*100.00/(SELECT COUNT(delivery_order_id) FROM orders),'N') "%OF_SALES", -- FOR BETTER UNDERSTANDING, SHOWING the Percentage of contribution of this channel to total sales
	--Calculationg the average and standard deviation for both order cycle time and orderfulfillment time when needed data is available 
	AVG(CASE WHEN order_moment_delivering IS NOT NULL AND order_moment_ready IS NOT NULL THEN DATEDIFF(HOUR, order_moment_created, order_moment_delivering) END) AS 'AVG_Order_cycle_time (H)',
	AVG(CASE WHEN order_moment_ready IS NOT NULL AND order_moment_delivering IS NOT NULL THEN DATEDIFF(HOUR, order_moment_created, order_moment_ready) END) AS 'AVG_Order Fulfillment (H)',
	ROUND(STDEVP(CASE WHEN order_moment_delivering IS NOT NULL AND order_moment_ready IS NOT NULL THEN DATEDIFF(HOUR, order_moment_created, order_moment_delivering) END),2) AS 'STDEVP_Order_cycle_time_in_hours',
	ROUND(STDEVP(CASE WHEN order_moment_ready IS NOT NULL AND order_moment_delivering IS NOT NULL THEN DATEDIFF(HOUR, order_moment_created, order_moment_ready) END),2) AS 'STDEVP_Order Fulfillment Lead Time',
	COUNT(CASE WHEN order_status = 'CANCELED' THEN 1 END) ORDER_CANCELED,
	AVG(delivery_distance_meters) AS average_distance,
	MAX(delivery_distance_meters) AS Max_distance,
	MIN(delivery_distance_meters) AS Min_distance
FROM 
	orders
JOIN
	stores ON stores.store_id = orders.store_id
JOIN 
	payments ON payments.payment_order_id = orders.order_id
JOIN
	Modified_deliveries on Modified_deliveries.delivery_order_id = orders.delivery_order_id
GROUP BY 
	stores.store_id,
	store_name
GO;

SELECT *
FROM Store_status

ORDER BY
	CONVERT(FLOAT,REPLACE(SUM_REVENUE, ',', '')) 
DESC;

 -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


 DROP VIEW IF EXISTS Driver_status

 GO;
 -- Creating the driver_status view 
CREATE VIEW Driver_status as 
SELECT 
	drivers.driver_id,
	driver_modal,
	FORMAT(COUNT(Modified_deliveries.delivery_id),'N') #OF_SALES, -- Counting number of orders 
	FORMAT(COUNT(CASE WHEN order_moment_ready IS NOT NULL AND order_moment_delivering IS NULL THEN 1 END),'N') AS Orders_in_delevery, -- Assumig that order being ready with no delivering time means that order is on its way
	(SELECT COUNT(DISTINCT (cast(order_moment_delivering AS DATE)))FROM 
    orders
JOIN  Modified_deliveries ON Modified_deliveries.delivery_order_id = orders.order_id
JOIN drivers ON drivers.driver_id = Modified_deliveries.driver_id) AS Working_days,
	--Calculationg the average and standard deviation for both order cycle time and orderfulfillment time when needed data is available 
	AVG(CASE WHEN order_moment_delivering IS NOT NULL AND order_moment_ready IS NOT NULL THEN DATEDIFF(HOUR, order_moment_created, order_moment_delivering) END) AS 'AVG_Order_cycle_time (H)',
	AVG(CASE WHEN order_moment_ready IS NOT NULL AND order_moment_delivering IS NOT NULL THEN DATEDIFF(HOUR, order_moment_created, order_moment_ready) END) AS 'AVG_Order Fulfillment (H)',
	ROUND(STDEVP(CASE WHEN order_moment_delivering IS NOT NULL AND order_moment_ready IS NOT NULL THEN DATEDIFF(HOUR, order_moment_created, order_moment_delivering) END),2) AS 'STDEVP_Order_cycle_time_in_hours',
	ROUND(STDEVP(CASE WHEN order_moment_ready IS NOT NULL AND order_moment_delivering IS NOT NULL THEN DATEDIFF(HOUR, order_moment_created, order_moment_ready) END),2) AS 'STDEVP_Order Fulfillment Lead Time',
	COUNT(CASE WHEN order_status = 'CANCELED' THEN 1 END) ORDER_CANCELED,
	AVG(delivery_distance_meters) AS average_distance,
	MAX(delivery_distance_meters) AS Max_distance,
	MIN(delivery_distance_meters) AS Min_distance
FROM 
	Modified_deliveries
JOIN
	orders ON Modified_deliveries.delivery_order_id = orders.delivery_order_id
JOIN
	stores ON stores.store_id = orders.store_id
JOIN 
	payments ON payments.payment_order_id = orders.order_id
JOIN 
	drivers ON drivers. driver_id = Modified_deliveries.driver_id
GROUP BY 
	drivers.driver_id,
	driver_modal;
GO;

SELECT * 
FROM Driver_status
ORDER BY
	CAST(REPLACE(Orders_in_delevery, ',', '') AS float) 
DESC;

select 
	store_name,
	CASE WHEN delivery_distance_meters >= 800 THEN AVG(order_delivery_cost) END AS '>800',
	CASE WHEN delivery_distance_meters < 800 AND delivery_distance_meters >=1600 THEN ROUND(AVG(order_delivery_cost),2) END AS 'Between 500 and 1600',
	CASE WHEN delivery_distance_meters < 1600 AND delivery_distance_meters >=2500 THEN ROUND(AVG(order_delivery_cost),2) END AS 'Between 1601 and 2500',
	CASE WHEN delivery_distance_meters < 2500 AND delivery_distance_meters >=3500 THEN ROUND(AVG(order_delivery_cost),2) END AS 'Between 2501 and 3500',
	CASE WHEN delivery_distance_meters < 3500  THEN AVG(order_delivery_cost) END AS '<3500'
FROM 
	orders
JOIN
	Modified_deliveries ON Modified_deliveries.delivery_order_id = orders.delivery_order_id
JOIN
	stores ON stores.store_id = orders.store_id
JOIN 
	hubs ON hubs.hub_id = stores.hub_id
	
JOIN 
	payments ON payments.payment_order_id = orders.order_id
JOIN 
	drivers ON drivers. driver_id = Modified_deliveries.driver_id
GROUP BY 
	store_name


select 
	store_name,
	ROUND(AVG(order_delivery_cost),2) AVG_OVER_ALL,
	ROUND(AVG(CASE WHEN delivery_distance_meters <= 800 THEN order_delivery_cost END),2) AS '>800',
	ROUND(AVG(CASE WHEN delivery_distance_meters > 800 AND delivery_distance_meters <=1600 THEN order_delivery_cost END),2) 'Between 500 and 1600',
	ROUND(AVG(CASE WHEN delivery_distance_meters > 1600 AND delivery_distance_meters <=2500 THEN order_delivery_cost END),2) 'Between 1601 and 2500',
	ROUND(AVG(CASE WHEN delivery_distance_meters > 2500 AND delivery_distance_meters <=3500 THEN order_delivery_cost END),2) 'Between 2501 and 3500',
	ROUND(AVG(CASE WHEN delivery_distance_meters > 3500 THEN order_delivery_cost END),2) '<3500'
FROM 
	orders
JOIN
	Modified_deliveries ON Modified_deliveries.delivery_order_id = orders.delivery_order_id
JOIN
	stores ON stores.store_id = orders.store_id
JOIN 
	hubs ON hubs.hub_id = stores.hub_id
	
JOIN 
	payments ON payments.payment_order_id = orders.order_id
JOIN 
	drivers ON drivers. driver_id = Modified_deliveries.driver_id
GROUP BY 
	store_name

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Creating the 'Excel_analysis' view which will be exported as CSV file to be imported to excel file for further visual representation using pivot charts
-- Used software for exporting data is 'dbForge Studio for SQL Server'


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

DROP VIEW IF EXISTS Excel_analysis

GO;

-- Creating a view named Excel_analysis to provide a structured dataset for Excel analysis

CREATE VIEW Excel_analysis AS
SELECT
    -- Selecting various columns from different tables to include in the view
    delivery_id,
    order_id,
    channels.channel_id,
    hubs.hub_id,
    stores.store_id,
    drivers.driver_id,
    payments.payment_id,
    hub_name,
    hub_city,
    hub_state,
    channel_name,
    store_name,
    store_segment,
    order_status,
    delivery_status,
    payment_status,
    payment_method,
    driver_modal,
    driver_type,
    -- Extracting order creation date and time from order_moment_created
    SUBSTRING(CONVERT(nvarchar(25), order_moment_created), 1, CHARINDEX(' ', order_moment_created)) AS Order_creation_date,
    SUBSTRING(CONVERT(nvarchar(25), order_moment_created), CHARINDEX(' ', order_moment_created) + 1, 8) AS Order_creation_time,
    -- Extracting order delivering date and time from order_moment_delivering
    SUBSTRING(CONVERT(nvarchar(25), order_moment_delivering), 1, CHARINDEX(' ', order_moment_delivering)) AS Order_delivering_date,
    SUBSTRING(CONVERT(nvarchar(25), order_moment_delivering), CHARINDEX(' ', order_moment_delivering) + 1, 8) AS Order_delivering_time,
    -- Calculating order preparation time if data is available
    CASE
        WHEN order_moment_ready IS NOT NULL AND order_moment_created IS NOT NULL THEN CONVERT(nvarchar(5), DATEDIFF(HOUR, order_moment_created, order_moment_ready))
        ELSE 'No available data'
    END AS Order_preparation_time,
    order_metric_transit_time AS order_transit_time,
    order_metric_cycle_time AS order_cycle_time,
    order_amount,
    (order_delivery_cost + order_delivery_fee) AS Total_delivery_cost,
    payment_amount AS Total_revenue,
    payment_fee,
    delivery_distance_meters,
    hub_latitude,
    hub_longitude,
    store_latitude,
    store_longitude,
    -- Adding a flag for distinct orders
    CASE
        WHEN ROW_NUMBER() OVER(PARTITION BY order_id ORDER BY order_id) = 1 THEN 1
        ELSE 0
    END AS DISTINCT_ORDER
FROM
    orders 
JOIN
    payments ON payments.payment_order_id = orders.order_id
JOIN
    Modified_deliveries ON Modified_deliveries.delivery_order_id = orders.order_id
JOIN
    stores ON stores.store_id = orders.store_id
JOIN 
    channels ON channels.channel_id = orders.channel_id
JOIN 
    hubs ON hubs.hub_id = stores.hub_id
JOIN 
    drivers ON drivers.driver_id = Modified_deliveries.driver_id;

GO;