/*

Cleaning Data in SQL Queries

*/

Select *
From [housing_data].dbo.housedata

-- Standardize Date Format


Select saleDate, CONVERT(Date,SaleDate)
From [housing_data].dbo.housedata

USE [housing_data];
ALTER TABLE dbo.housedata
ADD SaleDateConverted DATE;

UPDATE [housing_data].dbo.housedata
SET SaleDate = CONVERT(DATE, SaleDate)
WHERE SaleDate IS NOT NULL;

Select *
From [housing_data].dbo.housedata

-- Populate Property Address data

Select *
From [housing_data].dbo.housedata
Where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From [housing_data].dbo.housedata a
JOIN [housing_data].dbo.housedata b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From [housing_data].dbo.housedata a
JOIN [housing_data].dbo.housedata b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

-- Seperate Address into Individual Columns (Address, City, State)

Select PropertyAddress
From [housing_data].dbo.housedata

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From [housing_data].dbo.housedata

USE [housing_data];
ALTER TABLE housedata
Add PropertySplitAddress Nvarchar(255);

Update housedata
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE housedata
Add PropertySplitCity Nvarchar(255);

Update housedata
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))




Select *
From [housing_data].dbo.housedata





Select OwnerAddress
From [housing_data].dbo.housedata



Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From [housing_data].dbo.housedata



ALTER TABLE housedata
Add OwnerSplitAddress Nvarchar(255);

Update housedata
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE housedata
Add OwnerSplitCity Nvarchar(255);

Update housedata
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE housedata
Add OwnerSplitState Nvarchar(255);

Update housedata
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From [housing_data].dbo.housedata




--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From [housing_data].dbo.housedata
Group by SoldAsVacant
order by 2




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From [housing_data].dbo.housedata


Update housedata
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END






-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From [housing_data].dbo.housedata
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From [housing_data].dbo.housedata




---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



Select *
From [housing_data].dbo.housedata


ALTER TABLE [housing_data].dbo.housedata
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate