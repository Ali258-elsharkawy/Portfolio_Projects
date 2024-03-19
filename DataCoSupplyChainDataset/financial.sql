-- Switching to DataCo_SC database 
USE DataCo_SC;


-- Exploring the table of Order_Data
SELECT *
FROM Order_Data;


-- Showing the profit per each product category
SELECT 
	Category_list.Category_Id,
	Category_name,
	ROUND(AVG(Benefit_per_order),2) 'AVG Profit',
	CASE 
		WHEN AVG(Benefit_per_order) >= 25 THEN 'High profit'
		WHEN AVG(Benefit_per_order) BETWEEN 20 AND 24.99 THEN 'Mediam profit'
		ELSE 'Low profit'
		END 'product classification'
FROM Order_Data
	JOIN Category_list ON Category_list.Category_Id = Order_Data.category_id
GROUP BY Category_name, Category_list.Category_Id
ORDER BY AVG(Benefit_per_order) DESC;


-- showing the profit per each product with categorization according to AVG profit of the product 
SELECT
	Product_list.product_category_id,
	Product_Name, 
	ROUND(AVG(Benefit_per_order),2) 'AVG Profit',
	CASE 
		WHEN AVG(Benefit_per_order) >= 25 THEN 'Star'
		WHEN AVG(Benefit_per_order) BETWEEN 20 AND 24.99 THEN 'Mediam profit'
		ELSE 'Low profit'
		END 'product classification'
FROM Order_Data
	JOIN Product_list ON Product_list.product_category_id = Order_Data.category_id
GROUP BY Product_Name, Product_list.Product_Category_Id
ORDER BY AVG(Benefit_per_order) DESC;


--Showing the profit per each department
SELECT 
	DEPARTMENT_LIST.Department_Id,
	Department_Name,
	ROUND(SUM(Benefit_per_order),2) 'Total profit'
FROM Department_List
	JOIN Order_Data 
		ON Department_List.Department_Id = Order_Data.Department_Id
GROUP BY 
	DEPARTMENT_LIST.Department_Id,
	Department_Name
ORDER BY [Total profit] DESC;


-- Showing the count of orders per region, number of items ordered, and the corresponding profit for these regions
SELECT 
	Order_Region,
	FORMAT(COUNT(Benefit_per_order),'N') 'orders per region',
	FORMAT(SUM(Order_Item_Quantity),'N') 'Total items ordered',
	FORMAT(ROUND(SUM(Benefit_per_order),2),'N') 'Total profit per region'
FROM ORDER_DATA
GROUP BY Order_Region 
ORDER BY SUM(Benefit_per_order) DESC;



-- Showing the profit corresponding for each state 
SELECT 
	Customer_State,
	ROUND(AVG(Benefit_per_order),2) 'AVG profit per day'
FROM Order_Data
	JOIN customer_data ON customer_data.Customer_Id = Order_Data.Order_Customer_Id
GROUP BY Customer_State
ORDER BY 'AVG profit per day' DESC;

-- showing the total profit for each customer segmant
SELECT
    Customer_Segment,
    FORMAT(ROUND(AVG(Benefit_per_order), 2), 'N') + ' $' AS AvgBenefit,
    FORMAT(ROUND(SUM(Benefit_per_order), 2), 'N') + ' $' AS SumBenefit
FROM 
    customer_data
    JOIN Order_Data ON Order_Data.Order_Customer_Id = customer_data.Customer_Id
GROUP BY 
    Customer_Segment
ORDER BY
	SUM(Benefit_per_order) DESC;


-- showing the daily profit
SELECT 
	ORDERdATE,
	ROUND(SUM(Benefit_per_order),2) 'Total profit per day'
FROM Order_Data
GROUP BY ORDERdATE
ORDER BY 'Total profit per day' DESC;


-- Showing the profit for each shipping mode
SELECT 
	Shipping_Mode,
	ROUND(AVG(Benefit_per_order),2) AS 'PROFIT PER EACH MODE'
FROM Order_Data
GROUP BY Shipping_Mode;


-- -- Selecting key information about products, department, and performance metrics
select
	product_list.Product_Card_Id,
	Department_Name,
	Product_Name,
	SUM(Order_Item_Quantity) '#Of orders per product',
	ROUND(Product_Price,2) 'Product price',
	FORMAT((SUM(Order_Item_Quantity) * ROUND(Product_Price,2)*(1-AVG(Order_Item_Discount_Rate))),'N') as 'Revenue',
	FORMAT(ROUND(SUM(Benefit_per_order),2),'N') 'Total profit per product',
	FORMAT(ROUND(AVG(Benefit_per_order),2),'N') 'AVG profit',
	CONVERT(varchar, ROUND(AVG(Order_Item_Profit_Ratio)*100,2),4) + ' %' 'AVG Profit percentage',
	CASE
		WHEN SUM(Benefit_per_order) > 700000 AND ROUND(AVG(Order_Item_Profit_Ratio)*100,2) > 15.00 THEN 'Star'
		WHEN SUM(Benefit_per_order) > 250000 AND ROUND(AVG(Order_Item_Profit_Ratio)*100,2) BETWEEN 12 AND 15 THEN 'Well performing product'
		WHEN SUM(Benefit_per_order) > 250000 AND ROUND(AVG(Order_Item_Profit_Ratio)*100,2) < 12.00 THEN 'High profit_Low margin'
		WHEN SUM(Benefit_per_order) < 250000 AND ROUND(AVG(Order_Item_Profit_Ratio)*100,2) > 17.00 THEN 'Low profit_High margin'
		ELSE 'Low profile'
	END 'Product Classification'
		
from Order_Data
	JOIN Product_list 
		ON
	Product_list.Product_Card_Id = Order_Data.Product_Card_Id             -- Joining Order_Data with Product_list
	JOIN Department_List
		ON 
	Order_Data.Department_Id = Department_List.Department_Id              -- Joining Order_Data with Department_List
GROUP BY Product_Name, product_list.Product_Card_Id,Product_Price,Department_Name
ORDER BY 
	SUM(Benefit_per_order) DESC,
	ROUND(AVG(Order_Item_Profit_Ratio)*100,2) DESC;
