create database DataCo_SC
use DataCo_SC

-- Setting attribute's Datatype for Order_Item_Id to INT with constrain of not null
alter table DataCoSupplyChainDataset
alter column Order_Item_Id int not null

alter table DataCoSupplyChainDataset
alter column Customer_State NVARCHAR (20) not null

-- Setting primary key to the large table
alter table DataCoSupplyChainDataset
add primary key (Order_Item_Id);

--starting with eploring all the data
SELECT Order_Customer_Id, Customer_Id
FROM DataCoSupplyChainDataset

-- finding the late delivery risk to all deliveries ratio
select CAST((SUM (CASE WHEN Late_delivery_risk = 1 THEN 1 ELSE 0 END) * 1.00/COUNT(*)) AS decimal (10,3)) Late_delivery_risk_ratio
FROM DataCoSupplyChainDataset;

-- giving an overview of how well the actual shipping days align with the scheduled shipping days. 
SELECT 
	COUNT(CASE WHEN Days_for_shipping_real < Days_for_shipment_scheduled THEN 1 END) AS EXCELLENT,
	COUNT(CASE WHEN Days_for_shipping_real = Days_for_shipment_scheduled THEN 1 END) AS ACCEPTABLE,
	COUNT(CASE WHEN Days_for_shipping_real BETWEEN Days_for_shipment_scheduled + 1 AND Days_for_shipment_scheduled +2 THEN 1 END) AS LATE,
	COUNT(CASE WHEN Days_for_shipping_real > Days_for_shipment_scheduled + 2 THEN 1 END) AS BAD_SITIUATION 
FROM Order_Data;
	


--this query state the number of payments for every payment methood and its ratio to the overall payments
SELECT
	type,
	FORMAT(COUNT (Type),'N') using_frequency,
	CAST((count(Type) *1.0 / SUM (count(Type)) OVER ()) *100 AS DECIMAL (10,2)) ratio_to_overall
FROM DataCoSupplyChainDataset 
group by Type
order by using_frequency DESC;


-- Analyzing shipping performance metrics based on different modes

SELECT 
    Shipping_Mode,  -- Shipping mode being analyzed
    CAST(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Order_Data) AS DECIMAL(10, 2)) AS 'Percentage of Customers',  
        -- Calculating the percentage of customers using each shipping mode
    COUNT(CASE WHEN Late_delivery_risk = 1 THEN 1 END) as 'Late delivery risk per type',  
        -- Counting the number of late delivery risks for each shipping mode
    CAST(COUNT(CASE WHEN Late_delivery_risk = 1 THEN 1 END) * 1.00 / COUNT(Late_delivery_risk) AS DECIMAL(10, 2)) 
        AS 'Late delivery risk ratio',  
        -- Calculating the ratio of late delivery risks to the total number of shipments for each mode
    COUNT(CASE WHEN Days_for_shipping_real > Days_for_shipment_scheduled THEN 1 END) 
        AS 'Number of late shipments',  
        -- Counting the number of shipments with actual days for shipping greater than scheduled
    CAST(COUNT(CASE WHEN Days_for_shipping_real > Days_for_shipment_scheduled THEN 1 END) * 1.00 / COUNT(Days_for_shipping_real) 
        AS DECIMAL(10, 2)) AS 'Percentage of shipments with late delivery'  
        -- Calculating the percentage of shipments with late delivery based on actual days and scheduled days
FROM Order_Data
GROUP BY Shipping_Mode; 


--Analyzing shipping duration statistics based on different shipping modes
SELECT 
	Shipping_Mode,
	ROUND(AVG(Days_for_shipping_real),2) 'AVG Sipping duration',
	ROUND(STDEVP(Days_for_shipping_real),3) 'STD For shipping duration ',
	ROUND(VAR(Days_for_shipping_real),3) as Shipping_duration_variance
FROM Order_Data
GROUP BY Shipping_Mode
ORDER BY [AVG Sipping duration] DESC

-- Optaining number of shipments corresponding to each sipping mode
SELECT 
	Shipping_Mode,
	COUNT(Order_Item_Id) 'Number of shipments'
FROM Order_Data
GROUP BY Shipping_Mode


-- Showing the number of shipments for each product
SELECT
	Product_list.Product_Card_Id,
	PRODUCT_NAME,
	SUM(Order_Item_Quantity) '#Of orders per product'
FROM Product_list
	JOIN Order_Data ON Product_list.Product_Card_Id = Order_Data.Product_Card_Id
GROUP BY  
	Product_list.Product_Card_Id, 
	PRODUCT_NAME
order by [#Of orders per product] DESC
