--PREVIEW OUR DATA

SELECT * 
FROM NashvilleHousing;

--------------------------------------------------------------------------------------------------
--STANDARDIZING THE DATE

SELECT SaleDate 
FROM NashvilleHousing;

SELECT SaleDate, CAST(SaleDate AS Date)
FROM NashvilleHousing;

ALTER TABLE NashvilleHousing
ADD SaleDate1 Date;

UPDATE NashvilleHousing
SET SaleDate1 = CONVERT(Date, SaleDate);

SELECT * 
FROM NashvilleHousing;

--------------------------------------------------------------------------------------------------
--POPULATING PROPERTYADDRESS COLUMN

SELECT *
FROM NashvilleHousing
WHERE PropertyAddress IS NULL;

SELECT *
FROM NashvilleHousing
--WHERE PropertyAddress IS NULL
ORDER BY ParcelID;

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
FROM NashvilleHousing a
JOIN NashvilleHousing b
ON a.ParcelID = b.ParcelID
AND a.UniqueID != b.UniqueID
WHERE a.PropertyAddress IS NULL;

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM NashvilleHousing a
JOIN NashvilleHousing b
ON a.ParcelID = b.ParcelID
AND a.UniqueID != b.UniqueID
WHERE a.PropertyAddress IS NULL;

UPDATE a
SET PropertyAddress=ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM NashvilleHousing a
JOIN NashvilleHousing b
ON a.ParcelID = b.ParcelID
AND a.UniqueID != b.UniqueID
WHERE a.PropertyAddress IS NULL;

--------------------------------------------------------------------------------------------------
--SPLITTING PROPERTYADDRESS INTO 2 COLUMNS (ADDRESS, CITY)
SELECT PropertyAddress
FROM NashvilleHousing

SELECT SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)) Address
FROM NashvilleHousing;

SELECT SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+2,LEN(PropertyAddress)) City
FROM NashvilleHousing;

ALTER TABLE NashvilleHousing
ADD Address1 nvarchar(255);

UPDATE NashvilleHousing
SET Address1 = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1);

ALTER TABLE NashvilleHousing
ADD City1 nvarchar(255);

UPDATE NashvilleHousing
SET City1 = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+2,LEN(PropertyAddress));

SELECT *
FROM NashvilleHousing

--------------------------------------------------------------------------------------------------
--SPLITTING OWNERADDRESS INTO 3 (ADDRESS, CITY, STATE)

SELECT OwnerAddress
FROM NashvilleHousing;

SELECT PARSENAME(REPLACE(OwnerAddress,',','.'),3) Address2, 
PARSENAME(REPLACE(OwnerAddress,',','.'),2) City2, 
PARSENAME(REPLACE(OwnerAddress,',','.'),1) State2
FROM NashvilleHousing;

ALTER TABLE NashvilleHousing
ADD Address2 nvarchar(255);

UPDATE NashvilleHousing
SET Address2=PARSENAME(REPLACE(OwnerAddress,',','.'),3);

ALTER TABLE NashvilleHousing
ADD City2 nvarchar(255);

UPDATE NashvilleHousing
SET City2=PARSENAME(REPLACE(OwnerAddress,',','.'),2);

ALTER TABLE NashvilleHousing
ADD State2 nvarchar(255);

UPDATE NashvilleHousing
SET State2=PARSENAME(REPLACE(OwnerAddress,',','.'),1);

--SELECT * 
--FROM NashvilleHousing

--------------------------------------------------------------------------------------------------
--CHANGING Y/N IN SOLDASVACANT COLUMN TO YES/NO

SELECT DISTINCT(SoldAsVacant)
FROM NashvilleHousing;

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2;

SELECT SoldAsVacant,
CASE
WHEN SoldAsVacant='N' THEN 'NO'
WHEN SoldAsVacant='Y' THEN 'YES'
ELSE SoldAsVacant
END
FROM NashvilleHousing;

UPDATE NashvilleHousing
SET SoldAsVacant=(CASE
WHEN SoldAsVacant='N' THEN 'NO'
WHEN SoldAsVacant='Y' THEN 'YES'
ELSE SoldAsVacant
END);


--------------------------------------------------------------------------------------------------
--REMOVING DUPLICATES WITH CTE

WITH rownumCTE AS (
SELECT *,
ROW_NUMBER () OVER(
PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
ORDER BY UniqueID
) row_num
FROM NashvilleHousing
--ORDER BY ParcelID
)
SELECT *
FROM rownumCTE
WHERE row_num>1
--ORDER BY PropertyAddress;

WITH rownumCTE AS (
SELECT *,
ROW_NUMBER () OVER(
PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
ORDER BY UniqueID
) row_num
FROM NashvilleHousing
--ORDER BY ParcelID
)
DELETE
FROM rownumCTE
WHERE row_num>1
--ORDER BY PropertyAddress;


--------------------------------------------------------------------------------------------------
--DELETING SOME UNNECESSARY COLUMNS

ALTER TABLE NashvilleHousing
DROP COLUMN PropertyAddress, SaleDate, OwnerAddress, TaxDistrict

SELECT * FROM NashvilleHousing

