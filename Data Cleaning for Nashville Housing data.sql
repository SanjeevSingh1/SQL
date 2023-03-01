Create database PortfolioProject

-- Standardize Date Format

select *
From PortfolioProject.dbo.Nashville_Housing

select SaleDate, CONVERT(Date,SaleDate)
From PortfolioProject.dbo.Nashville_Housing;

Update Nashville_Housing
SET SaleDate = CONVERT(Date,SaleDate)

Alter table Nashville_Housing
Add SaleDateConverted Date;

Update Nashville_Housing
SET SaleDateConverted = CONVERT(Date,SaleDate)

select SaleDateConverted
From PortfolioProject.dbo.Nashville_Housing;


-- Populate Proprty Address data

select *
from PortfolioProject.dbo.Nashville_Housing
where PropertyAddress is null

select *
from PortfolioProject.dbo.Nashville_Housing
order by ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject.dbo.Nashville_Housing a
JOIN PortfolioProject.dbo.Nashville_Housing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID]<>b.[UniqueID]
where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject.dbo.Nashville_Housing a
JOIN PortfolioProject.dbo.Nashville_Housing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID]<>b.[UniqueID]
where a.PropertyAddress is null


-- Breaking out Address into Individual column(Address, City, State)


select PropertyAddress
from PortfolioProject.dbo.Nashville_Housing
--where PropertyAddress is null

SELECT
SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress)) AS Address,
CHARINDEX(',',PropertyAddress)
from PortfolioProject.dbo.Nashville_Housing

SELECT
SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1) AS Address,
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) AS Address
from PortfolioProject.dbo.Nashville_Housing


Alter table Nashville_Housing
Add PropertySplitAddress Nvarchar(225);

Update Nashville_Housing
SET PropertySplitAddress = SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1)


Alter table Nashville_Housing
Add PropertySplitCity Nvarchar(225);

Update Nashville_Housing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))

Select * From PortfolioProject.dbo.Nashville_Housing


Select OwnerAddress From PortfolioProject.dbo.Nashville_Housing

Select 
PARSENAME(REPLACE(OwnerAddress, ',','.'), 3)
,PARSENAME(REPLACE(OwnerAddress, ',','.'), 2)
,PARSENAME(REPLACE(OwnerAddress, ',','.'), 1)
From PortfolioProject.dbo.Nashville_Housing


Alter table Nashville_Housing
Add OwnerSplitAddress Nvarchar(225);

Update Nashville_Housing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',','.'), 3)


Alter table Nashville_Housing
Add OwnerSplitCity Nvarchar(225);

Update Nashville_Housing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',','.'), 2)


Alter table Nashville_Housing
Add OwnerSplitState Nvarchar(225);

Update Nashville_Housing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',','.'), 1)


Select * From PortfolioProject.dbo.Nashville_Housing


--Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant), count(SoldAsVacant)
From PortfolioProject.dbo.Nashville_Housing
Group by SoldAsVacant
order by 2

select SoldAsVacant 
, Case when SoldAsVacant = 'Y' then 'Yes'
	   when SoldAsVacant = 'N' then 'No'
	   Else SoldAsVacant
	   End
From PortfolioProject.dbo.Nashville_Housing


update Nashville_Housing
SET SoldAsVacant = Case when SoldAsVacant = 'Y' then 'Yes'
	   when SoldAsVacant = 'N' then 'No'
	   Else SoldAsVacant
	   End



-- Remove Duplicates

WITH RowNumCTE As(
select *,
	ROW_NUMBER()OVER(
	PARTITION BY ParcelID,PropertyAddress,SalePrice,SaleDate,LegalReference 
	ORDER BY
		UniqueID)row_num

From PortfolioProject.dbo.Nashville_Housing
)
select*
From RowNumCTE
where row_num > 1
order by PropertyAddress


WITH RowNumCTE As(
select *,
	ROW_NUMBER()OVER(
	PARTITION BY ParcelID,PropertyAddress,SalePrice,SaleDate,LegalReference 
	ORDER BY
		UniqueID)row_num

From PortfolioProject.dbo.Nashville_Housing
)
DELETE
From RowNumCTE
where row_num > 1



-- Delete Unused Columns


select * From PortfolioProject.dbo.Nashville_Housing

ALTER TABLE PortfolioProject.dbo.Nashville_Housing
DROP COLUMN OwnerAddress, PropertyAddress, TaxDistrict

ALTER TABLE PortfolioProject.dbo.Nashville_Housing
DROP COLUMN SaleDate
