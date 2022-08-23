select * from NashvilleHousing

--Standrdize Date format

select SaleDate,CONVERT(date,SaleDAte)
from NashvilleHousing

update NashvilleHousing set SaleDate = CONVERT(date,SaleDAte)
--above 2 queirs are not working so I will create an alternative coulmn

alter table NashvilleHousing
add SaleDateConverted Date;

update NashvilleHousing set SaleDateConverted = CONVERT(date,SaleDAte)

select SaleDateConverted,SaleDate
from NashvilleHousing



--Populate Property Address Date

----finding NULL values
select *
from NashvilleHousing where PropertyAddress is NuLL
order by ParcelID

----finding a relative field 
select  a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from NashvilleHousing a join NashvilleHousing b on a.ParcelID=b.ParcelID
and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is Null

update a 
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from NashvilleHousing a join NashvilleHousing b on a.ParcelID=b.ParcelID
and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is Null

----double check if I still have NULL values
select *
from NashvilleHousing where PropertyAddress is NuLL
order by ParcelID




--Breaking out Address into indivual coulmns (Address,city)

select PropertyAddress from NashvilleHousing

select SUBSTRING(PropertyAddress,1 , CHARINDEX(',',PropertyAddress)-1)
,SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1 , len(PropertyAddress))
from NashvilleHousing

alter table NashvilleHousing
add PropertySplitAddress nvarchar(255)

update NashvilleHousing set PropertySplitAddress = SUBSTRING(PropertyAddress,1 , CHARINDEX(',',PropertyAddress)-1)

alter table NashvilleHousing
add PropertySplitCity nvarchar(255)

update NashvilleHousing set PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1 , len(PropertyAddress))


--Breaking out Address into induvual coulmns (Address,city,state) but to owner with another way

select OwnerAddress from NashvilleHousing


select 
PARSENAME(replace(OwnerAddress,',','.'),3),
PARSENAME(replace(OwnerAddress,',','.'),2),
PARSENAME(replace(OwnerAddress,',','.'),1)
from NashvilleHousing

alter table NashvilleHousing
add OwnerSplitAddress nvarchar(255)

update NashvilleHousing set OwnerSplitAddress = PARSENAME(replace(OwnerAddress,',','.'),3)

alter table NashvilleHousing
add OwnerSplitCity nvarchar(255)

update NashvilleHousing set OwnerSplitCity = PARSENAME(replace(OwnerAddress,',','.'),2)

alter table NashvilleHousing
add OwnerSplitState nvarchar(255)

update NashvilleHousing set OwnerSplitState = PARSENAME(replace(OwnerAddress,',','.'),1)

-------------------------------
--Change Y and N to Yes and No in "Sold as Vacant"

select  SoldAsVacant,
case when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	else SoldAsVacant
	end
from NashvilleHousing

update NashvilleHousing set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	else SoldAsVacant
	end

select distinct SoldAsVacant
from NashvilleHousing

------------------------------------------------

--Removing Duplicates

with RowNUMCTE as (
select *,ROW_NUMBER() over (partition by ParcelId,PropertyAddress,SalePrice,SaleDate,LegalReference order by UniqueID) as RowNum
from NashvilleHousing)

select * from RowNUMCTE
where RowNum > 1

------------------------------------------------

--Delete Unused columns

Alter table NashvilleHousing
drop column SaleDate

select * from NashvilleHousing

