-- Switching to the database 
use DataCo_SC

-- Exporing the mastertable to break it down into smaller tables 
SELECT *
FROM DataCoSupplyChainDataset

-- creating the first table which contain only the data of customer info
DROP TABLE IF EXISTS customer_data;
SELECT DISTINCT
    Customer_Id,
    CONCAT(Customer_Fname, ' ', Customer_Lname) AS Full_name,
    Customer_Segment,
    Customer_Country,
    Customer_State,
    Customer_City,
    Customer_Zipcode,
    Customer_Street,
    Customer_Email,
    Customer_Password
INTO customer_data
FROM DataCoSupplyChainDataset;

-- exploring the first table 
SELECT *
FROM customer_data 

--Adding NOT NULL constrain to the column Customer_Id
ALTER TABLE customer_data
ALTER COLUMN Customer_Id INT NOT NULL

-- After meeting the unnull constrain to the column Customer_Id set it to be the primary key 
ALTER TABLE customer_data
ADD PRIMARY KEY (Customer_Id)



--------------------------------------------------------------------------------------------------------------------


-- creating the second table which contain only the data for departments 
DROP TABLE IF EXISTS Department_List
SELECT DISTINCT 
	Department_Id,
	Department_Name
	INTO Department_List
FROM DataCoSupplyChainDataset

--Adding NOT NULL constrain to the column Department_Id
ALTER TABLE Department_List
ALTER COLUMN Department_Id INT NOT NULL

-- After meeting the unnull constrain to the column Department_Id set it to be the primary key 
ALTER TABLE Department_List
ADD PRIMARY KEY (Department_Id)

-- Exploring the data for the second table 
SELECT* 
FROM Department_List


----------------------------------------------------------------------------------------------------------------


-- Creating the third table which contains the data for all products 
DROP TABLE IF EXISTS Product_list
SELECT DISTINCT
	Product_Card_Id,
	Product_Category_Id,
	Department_Id,
	Product_Name,
	Category_Id,
	Product_Image,
	Product_Price,
	Product_Status,
	Product_Description
INTO Product_list
FROM DataCoSupplyChainDataset

SELECT*
FROM Product_list

-- Adding the constrain of not nullable th the column Product_Card_Id
ALTER TABLE Product_list
ALTER COLUMN Product_Card_Id INT NOT NULL

-- After meeting the unnullable constrain set the column Product_Card_Id to be the primary key 
ALTER TABLE Product_list
ADD PRIMARY KEY (Product_Card_Id)

-- Setting the data type of Department_Id for the table 'Product_list' to be INT as the data type of Department_Id for the table 'Department_data'
ALTER TABLE Product_list
ALTER COLUMN Department_Id INT

ALTER TABLE Product_list
ADD FOREIGN KEY (Department_Id) REFERENCES Department_List(Department_Id)

ALTER TABLE Product_list
ALTER COLUMN Product_Category_Id INT

ALTER TABLE Product_list
ADD FOREIGN KEY (Product_Category_Id) REFERENCES Category_list(Category_Id);


--------------------------------------------------------------------------------------------------------------------------------------


--Creating the fourth table with name of Category_list which contains list of all categories the store has  
DROP TABLE IF EXISTS Category_list
SELECT DISTINCT
	Category_Id,
	Category_Name
INTO Category_list
FROM DataCoSupplyChainDataset

SELECT*
FROM Category_list

-- Adding the constrain of not nullable th the column Category_Id
ALTER TABLE Category_list
ALTER COLUMN Category_Id INT NOT NULL

-- After meeting the unnullable constrain set the column Category_Id to be the primary key 
ALTER TABLE Category_list
ADD PRIMARY KEY (Category_Id)


-------------------------------------------------------------------------------------------------------------------------------------------


--Creating the fifth table with name of order_data table which contains records for all items sold with detais for the transaction
DROP TABLE IF EXISTS Order_Data
SELECT 
	Order_Item_Id,
	Order_Id,
	Product_Card_Id,
	Order_Item_Cardprod_Id,
	Order_Customer_Id,
	Category_Id,
	Department_Id,
	SUBSTRING(CONVERT(VARCHAR, order_date_DateOrders, 120), 1, CHARINDEX(' ', CONVERT(VARCHAR, order_date_DateOrders, 120)) - 1) AS OrderDate,
	SUBSTRING(CONVERT(VARCHAR, order_date_DateOrders, 120),CHARINDEX(' ',order_date_DateOrders )+1,LEN(order_date_DateOrders)-CHARINDEX(' ', CONVERT(VARCHAR, order_date_DateOrders, 120))) AS OrderTIME,
	Order_Item_Quantity,
	Order_Status,
	Order_Item_Discount,
	Order_Item_Discount_Rate,
	Benefit_per_order,
	Order_Item_Profit_Ratio,
	Days_for_shipment_scheduled,
	Days_for_shipping_real, 
	Shipping_Mode,
	Late_delivery_risk,
	Delivery_Status,
	Order_Region,
	Order_State,
	Order_City,
	Order_Item_Product_Price
INTO Order_Data
FROM DataCoSupplyChainDataset

SELECT*
FROM Order_Data

--adding the unnullable constrain to the column Order_Item_Id
ALTER TABLE Order_Data
ALTER COLUMN Order_Item_Id INT NOT NULL

--after setting the datatype for the column Order_Item_Id and meeting the unnullable constrain, setting this column to be the primary key
ALTER TABLE Order_Data
ADD PRIMARY KEY (Order_Item_Id)

-- aligning the datatype for the foreign key for this table with the datatype of primary key for the tables wanted to be linked then link them 


ALTER TABLE Order_Data
ALTER COLUMN Order_Customer_Id INT

ALTER TABLE Order_Data
ADD FOREIGN KEY (Order_Customer_Id) REFERENCES customer_data(Customer_Id)

ALTER TABLE Order_Data
ALTER COLUMN Product_Card_Id INT

ALTER TABLE Order_Data
ADD FOREIGN KEY (Product_Card_Id) REFERENCES PRODUCT_LIST(Product_Card_Id)

ALTER TABLE Order_Data
ALTER COLUMN Category_Id INT

ALTER TABLE Order_Data
ADD FOREIGN KEY (Category_Id) REFERENCES Category_list(Category_Id)

ALTER TABLE Order_Data
ALTER COLUMN Department_Id INT

ALTER TABLE Order_Data
ADD FOREIGN KEY (Department_Id) REFERENCES department_list(Department_Id)