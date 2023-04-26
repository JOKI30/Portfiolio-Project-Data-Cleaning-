


SELECT * 
FROM [Portfolio Project].dbo.NashvilleHousing

--Standardadize Date Format

SELECT SaleDateConverted, CONVERT (Date, SaleDate)
FROM [Portfolio Project].dbo.NashvilleHousing


UPDATE [Portfolio Project].dbo.NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE [Portfolio Project].dbo.NashvilleHousing
ADD SaleDateConverted Date;

UPDATE [Portfolio Project].dbo.NashvilleHousing
SET SaleDateCOnverted = CONVERT(Date, SaleDate)

--Populate Property Address Data 


SELECT *
FROM [Portfolio Project].dbo.NashvilleHousing
--WHERE PropertyAddress is NULL
ORDER BY ParcelID

SELECT A.ParcelID, A.PropertyAddress, B.ParcelID, B.PropertyAddress, ISNULL(A.PropertyAddress, B.PropertyAddress)
FROM [Portfolio Project].dbo.NashvilleHousing A
JOIN [Portfolio Project].dbo.NashvilleHousing B
	ON A.ParcelID = B.ParcelID
	AND A.[UniqueID] <> B.[UniqueID]
WHERE A.PropertyAddress is null 

UPDATE A 
SET PropertyAddress = ISNULL(A.PropertyAddress, B.PropertyAddress)
FROM [Portfolio Project].dbo.NashvilleHousing A
JOIN [Portfolio Project].dbo.NashvilleHousing B
	ON A.ParcelID = B.ParcelID
	AND A.[UniqueID] <> B.[UniqueID]
WHERE A.PropertyAddress is null 


--Breaking out Address into Individual Columns (Address, City, State) 

SELECT PropertyAddress
FROM [Portfolio Project].dbo.NashvilleHousing
--WHERE PropertyAddress is NULL 
--ORDER BY ParceelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) AS Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress)) AS Address 
FROM [Portfolio Project].dbo.NashvilleHousing



ALTER TABLE [Portfolio Project].dbo.NashvilleHousing
ADD PropertySplitAddress Nvarchar(255);

UPDATE [Portfolio Project].dbo.NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

ALTER TABLE [Portfolio Project].dbo.NashvilleHousing
ADD PropertySplitCity Nvarchar(255);

UPDATE [Portfolio Project].dbo.NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress))


SELECT * 
FROM [Portfolio Project].dbo.NashvilleHousing


SELECT OwnerAddress
FROM [Portfolio Project].dbo.NashvilleHousing

SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
FROM [Portfolio Project].dbo.NashvilleHousing




ALTER TABLE [Portfolio Project].dbo.NashvilleHousing
ADD OwnerSplitAddress Nvarchar(255);

UPDATE [Portfolio Project].dbo.NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

ALTER TABLE [Portfolio Project].dbo.NashvilleHousing
ADD OwnerSplitCity Nvarchar(255);

UPDATE [Portfolio Project].dbo.NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

ALTER TABLE [Portfolio Project].dbo.NashvilleHousing
ADD OwnerSplitState Nvarchar(255);

UPDATE [Portfolio Project].dbo.NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

SELECT OwnerAddress
FROM [Portfolio Project].dbo.NashvilleHousing



--CHANGE Y and N to Yes and No in "Sold as Vacant" field

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM [Portfolio Project].dbo.NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant
, CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	   WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
FROM [Portfolio Project].dbo.NashvilleHousing

UPDATE [Portfolio Project].dbo.NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	   WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END



--Remove Duplicates

WITH RowNumCTE AS( 
SELECT *, 
        ROW_NUMBER() OVER (
		PARTITION BY ParcelID, 
								PropertyAddress,
								SalePrice,
								SaleDate,
								LegalReference
								ORDER BY
										UniqueID
										) row_num
FROM [Portfolio Project].dbo.NashvilleHousing
--ORDER BY ParcelID
)
SELECT * 
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress

----------------------------------------------------------
--DELETE DUPLICATE STRING 

WITH RowNumCTE AS( 
SELECT *, 
        ROW_NUMBER() OVER (
		PARTITION BY ParcelID, 
								PropertyAddress,
								SalePrice,
								SaleDate,
								LegalReference
								ORDER BY
										UniqueID
										) row_num
FROM [Portfolio Project].dbo.NashvilleHousing
--ORDER BY ParcelID
)
DELETE  
FROM RowNumCTE
WHERE row_num > 1
--ORDER BY PropertyAddress


--Delete Unused Columns

SELECT * 
FROM [Portfolio Project].dbo.NashvilleHousing

ALTER TABLE [Portfolio Project].dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

ALTER TABLE [Portfolio Project].dbo.NashvilleHousing
DROP COLUMN SaleDate

