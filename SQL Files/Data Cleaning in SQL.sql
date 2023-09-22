-- selecting both SalesDateConverted and SaleDate after conversion to ensure they are the same
select
	SalesDateConverted,
	CONVERT(date, SaleDate)
from Portfolio_Project..NashvilleHousing

-- Adding the column of SalesDateConverted
ALTER TABLE Portfolio_Project..NashvilleHousing
ADD SalesDateConverted Date;

-- Setting the values for SalesDateConverted
UPDATE Portfolio_Project..NashvilleHousing
SET SalesDateConverted = CONVERT (DATE, SaleDate)

-- selecting the null Property Address where there are problem
SELECT *
FROM Portfolio_Project..NashvilleHousing
where PropertyAddress IS NULL
ORDER BY ParcelID

-- Selecting the data where two different rows have the same parce ID WHERE Property Address IS NULL
SELECT
	a.ParcelID,
	a.[UniqueID ],
	b.ParcelID,
	b.[UniqueID ],
	a.PropertyAddress,
	b.PropertyAddress,
	ISNULL(a.PropertyAddress,b.PropertyAddress) AS New_Adress
FROM Portfolio_Project..NashvilleHousing AS a
join Portfolio_Project..NashvilleHousing AS b
ON a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

-- Updating the null values
UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM Portfolio_Project..NashvilleHousing AS a
join Portfolio_Project..NashvilleHousing AS b
ON a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

-- spliting the full adress into adress and city
SELECT
	PropertyAddress,
	SUBSTRING(PropertyAddress, 1, CHARINDEX (',', PropertyAddress)-1) as adress,
	SUBSTRING (PropertyAddress, CHARINDEX (',', PropertyAddress)+1, LEN(PropertyAddress)) as City
from Portfolio_Project..NashvilleHousing

-- add the column of PropertySplitAddress
alter TABLE Portfolio_Project..NashvilleHousing
add PropertySplitAddress NVARCHAR(225);

-- add the column of PropertySplitCity
alter TABLE Portfolio_Project..NashvilleHousing
add PropertySplitCity NVARCHAR(225);

-- Setting the values of PropertySplitAddress
UPDATE Portfolio_Project..NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX (',', PropertyAddress)-1)

-- Setting the values of PropertySplitCity
UPDATE Portfolio_Project..NashvilleHousing
SET PropertySplitCity = SUBSTRING (PropertyAddress, CHARINDEX (',', PropertyAddress)+1, LEN(PropertyAddress))

-- Selecting the full adress and splitting it
SELECT
	OwnerAddress,
	PARSENAME(REPLACE(OwnerAddress,',','.'),3),
	PARSENAME(REPLACE(OwnerAddress,',','.'),2),
	PARSENAME(REPLACE(OwnerAddress,',','.'),1)
FROM Portfolio_Project..NashvilleHousing


-- creating column for owner adress and giving its values
ALTER TABLE Portfolio_Project..NashvilleHousing
ADD OwnerSplitAddres NVARCHAR(225);

UPDATE Portfolio_Project..NashvilleHousing
SET OwnerSplitAddres = PARSENAME(REPLACE(OwnerAddress,',','.'),3)


-- creating column for owner City and giving its values
ALTER TABLE Portfolio_Project..NashvilleHousing
ADD OwnerSplitCity NVARCHAR(225);

UPDATE Portfolio_Project..NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)


-- creating column for owner State and giving its values
ALTER TABLE Portfolio_Project..NashvilleHousing
ADD OwnerSplitState NVARCHAR(225);

UPDATE Portfolio_Project..NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)

-- sellecting all the data in the column to Check for the changes
SELECT *
FROM Portfolio_Project..NashvilleHousing


-- Shoing the DISTINCT values for the data in this column and there were 4 values: 'Yes','No','Y', and 'N'
SELECT
	DISTINCT (SoldAsVacant)
FROM Portfolio_Project..NashvilleHousing

-- Updating the Values to Contain one way to answer 'Yes' and one way to answer 'No'
UPDATE Portfolio_Project..NashvilleHousing
SET SoldAsVacant = CASE
		WHEN SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
	END;


	-- Selecting the duplicates in the data and delete them

WITH RownNumCTE AS
	(SELECT*,
	ROW_NUMBER() OVER(
	PARTITION BY
		parcelID,
		PropertyAddress,
		SalePrice,
		SaleDate,
		LegalReference
	ORDER BY
		UniqueID
	) AS RownNum
	FROM Portfolio_Project..NashvilleHousing
)

SELECT *
-- DELETE *
FROM RownNumCTE
WHERE RownNum >1;

-- Creating a copy of the original table and delete the unwanted columns of OwnerAddress, PropertyAddress, and TaxDistrict from it
DROP TABLE IF EXISTS #DataForDeleteColumns
SELECT *
INTO #DataForDeleteColumns
from Portfolio_Project..NashvilleHousing 

Alter table #DataForDeleteColumns
drop column OwnerAddress,
PropertyAddress,
TaxDistrict,
SaleDate

SELECT *
from #DataForDeleteColumns 