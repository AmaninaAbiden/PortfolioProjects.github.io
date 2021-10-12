
Select *
From NashvilleHousing..Nashville_housing

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format 

ALTER TABLE NashvilleHousing..Nashville_housing
ADD SaleDateConverted Date;

Update NashvilleHousing..Nashville_housing
SET SaleDateConverted = CONVERT(Date,SaleDate)

 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data
-- Some data has duplicate ParcelID but might or might not have the corresponding PropertyAddress in the database

Select *
From NashvilleHousing..Nashville_housing
Where PropertyAddress is null
order by ParcelID

Select a.[UniqueID ], a.ParcelID, a.PropertyAddress, b.[UniqueID ], b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From NashvilleHousing..Nashville_housing a JOIN NashvilleHousing..Nashville_housing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] != b.[UniqueID ]
Where a.PropertyAddress IS NULL

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From NashvilleHousing..Nashville_housing a
JOIN NashvilleHousing..Nashville_housing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] != b.[UniqueID ]
Where a.PropertyAddress is null

--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)


Select PropertyAddress
From NashvilleHousing..Nashville_housing

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as City
FROM NashvilleHousing..Nashville_housing

ALTER TABLE NashvilleHousing..Nashville_housing
ADD PropertySplitAddress Nvarchar(255);

UPDATE NashvilleHousing..Nashville_housing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)


ALTER TABLE NashvilleHousing..Nashville_housing
ADD PropertySplitCity Nvarchar(255)

UPDATE NashvilleHousing..Nashville_housing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

Select *
From NashvilleHousing..Nashville_housing

Select OwnerAddress
From NashvilleHousing..Nashville_housing

SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
FROM NashvilleHousing..Nashville_housing

ALTER TABLE NashvilleHousing..Nashville_housing
ADD OwnerSplitAddress Nvarchar(255)

UPDATE NashvilleHousing..Nashville_housing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

ALTER TABLE NashvilleHousing..Nashville_housing
ADD OwnerSplitCity Nvarchar(255)

UPDATE NashvilleHousing..Nashville_housing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

ALTER TABLE NashvilleHousing..Nashville_housing
ADD OwnerSplitState Nvarchar(255)

UPDATE NashvilleHousing..Nashville_housing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

SELECT TRIM(' ' FROM OwnerSplitCity)
FROM NashvilleHousing..Nashville_housing

UPDATE NashvilleHousing..Nashville_housing
SET OwnerSplitCity = TRIM(' ' FROM OwnerSplitCity)

SELECT TRIM(' ' FROM OwnerSplitState)
FROM NashvilleHousing..Nashville_housing

UPDATE NashvilleHousing..Nashville_housing
SET OwnerSplitState = TRIM(' ' FROM OwnerSplitState)

Select *
FROM NashvilleHousing..Nashville_housing


--------------------------------------------------------------------------------------------------------------------------

-- Change Y and N to Yes and No in "Sold as Vacant" field

SELECT DISTINCT(SoldAsVacant), Count(SoldAsVacant)
FROM NashvilleHousing..Nashville_housing
GROUP BY SoldAsVacant

SELECT SoldAsVacant,
	CASE 
		WHEN SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
   END
FROM NashvilleHousing..Nashville_housing


UPDATE NashvilleHousing..Nashville_housing
SET SoldAsVacant = CASE 
						WHEN SoldAsVacant = 'Y' THEN 'Yes'
						WHEN SoldAsVacant = 'N' THEN 'No'
						ELSE SoldAsVacant
					END

-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

SELECT DISTINCT [ParcelID] FROM NashvilleHousing..Nashville_housing

SELECT *,
		ROW_NUMBER() OVER (
		PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY UniqueID
				) row_num
FROM NashvilleHousing..Nashville_housing
ORDER BY row_num

WITH RowNumCTE AS(
	SELECT *,
		ROW_NUMBER() OVER (
		PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY UniqueID
				) row_num
	FROM NashvilleHousing..Nashville_housing
	)

SELECT *
FROM RowNumCTE
WHERE row_num > 1

--Put the duplicate data into another table
WITH RowNumCTE AS(
	SELECT *,
		ROW_NUMBER() OVER (
		PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY UniqueID
				) row_num
	FROM NashvilleHousing..Nashville_housing
	)

SELECT *
INTO NashvilleHousing..Nashville_housing_duplicatedata
FROM RowNumCTE
WHERE row_num > 1

--Delete the duplicate rows
WITH RowNumCTE AS(
	SELECT *,
		ROW_NUMBER() OVER (
		PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY UniqueID
				) row_num
	FROM NashvilleHousing..Nashville_housing
	)

DELETE
FROM RowNumCTE
WHERE row_num > 1


SELECT *
FROM NashvilleHousing..Nashville_housing

SELECT *
FROM NashvilleHousing..Nashville_housing_duplicatedata


---------------------------------------------------------------------------------------------------------

-- Delete Unused Column


Select *
From NashvilleHousing..Nashville_housing

ALTER TABLE NashvilleHousing..Nashville_housing
DROP COLUMN SaleDate


