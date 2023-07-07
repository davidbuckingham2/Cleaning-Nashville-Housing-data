-- Cleaning Data in SQL Queries

SELECT *
FROM PortfolioProject.dbo.NashvilleHousing$

--------------------------------------------------------------------------------------------------------------

-- Standardize Date Format

ALTER TABLE NashvilleHousing$
ADD SaleDateConverted Date;

Update NashvilleHousing$
SET SaleDateConverted = CONVERT(Date,SaleDate)

SELECT saleDateConverted, CONVERT(Date,SaleDate)
FROM NashvilleHousing$

--------------------------------------------------------------------------------------------------------------
-- Populate Property Address data

SELECT *
FROM NashvilleHousing$
--Where PropertyAddress is null
ORDER BY ParcelID


SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM NashvilleHousing$ AS a
JOIN NashvilleHousing$ AS b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM NashvilleHousing$ AS a
JOIN NashvilleHousing$ AS b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL



--------------------------------------------------------------------------------------------------------------

-- Breaking up Address into Individual Columns(Address, City, State)

SELECT PropertyAddress
FROM NashvilleHousing$

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) AS address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) AS city
From NashvilleHousing$


ALTER TABLE NashvilleHousing$
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing$
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE NashvilleHousing$
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing$
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))


------------------------------------------------------------------------------------------------------------------

-- Split OwnerAddress using PARSENAME 

SELECT OwnerAddress
FROM NashvilleHousing$


SELECT
PARSENAME(REPLACE(OwnerAddress, ',','.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',','.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',','.'), 1)
FROM NashvilleHousing$



ALTER TABLE NashvilleHousing$
Add OwnerSplitAddress Nvarchar(255);


ALTER TABLE NashvilleHousing$
Add OwnerSplitCity Nvarchar(255);


ALTER TABLE NashvilleHousing$
Add OwnerSplitState Nvarchar(255);


UPDATE NashvilleHousing$
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


UPDATE NashvilleHousing$
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)


UPDATE NashvilleHousing$
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)


--------------------------------------------------------------------------------------------------------------------------

-- Change Y and N to Yes and No in "Sold as Vacant" field so that we only have 2 distinct values

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM NashvilleHousing$
GROUP BY SoldAsVacant
ORDER BY 2

 
SELECT SoldAsVacant,
	CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
		 WHEN SoldAsVacant = 'N' THEN 'No'
		 ELSE SoldAsVacant
		 END
FROM NashvilleHousing$


UPDATE NashvilleHousing$
SET SoldAsVacant = 	CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
		 WHEN SoldAsVacant = 'N' THEN 'No'
		 ELSE SoldAsVacant
		 END



-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 propertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num
FROM NashvilleHousing$
)
DELETE 
FROM RowNumCTE
WHERE row_num > 1
--ORDER BY PropertyAddress




---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns

SELECT *
FROM NashvilleHousing$


ALTER TABLE NashvilleHousing$
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate