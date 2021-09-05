/*
 Cleaning Data
 */

 Select * from PortfolioProjects..NashvilleHousing

 --Standardize Date Format
  Select SaleDateConverted, Convert(Date, SaleDate)
  from PortfolioProjects..NashvilleHousing

  -----------------------------------------------------------------

  --Method 1
  Update NashvilleHousing
  Set SaleDate = CONVERT(Date, SaleDate)

  --Method 2
  Alter Table NashvilleHousing
  Add SaleDateConverted Date;

  Update NashvilleHousing
  Set SaleDateConverted = CONVERT(Date, SaleDate)




  -------------------------------------------------------------------------------

  --Populate Property Address data
  Select *
  from PortfolioProjects..NashvilleHousing
  --where PropertyAddress is null
  order by ParcelID


  --self join 
 select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
 from PortfolioProjects..NashvilleHousing a
 join PortfolioProjects..NashvilleHousing b
     on a.ParcelID = b.ParcelID and a.[UniqueID ] <> b. [UniqueID ]
 where a.PropertyAddress is null


 Update a
 Set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
 from PortfolioProjects..NashvilleHousing a
 join PortfolioProjects..NashvilleHousing b
     on a.ParcelID = b.ParcelID and a.[UniqueID ] <> b. [UniqueID ]
 where a.PropertyAddress is null



 ------------------------------------------------------------------------------------------

--Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress
from PortfolioProjects..NashvilleHousing
--where PropertyAddress is null
--order by ParcelID


-- SUBSTRING()
select 
SUBSTRING(PropertyAddress, 1, Charindex(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, Charindex(',', PropertyAddress) +1 , LEN(PropertyAddress)) as Address
from  PortfolioProjects..NashvilleHousing



Alter Table NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, Charindex(',', PropertyAddress) -1 )


Alter Table NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
Set PropertySplitCity = SUBSTRING(PropertyAddress, Charindex(',', PropertyAddress) +1 , LEN(PropertyAddress))



select * from  PortfolioProjects..NashvilleHousing



-- PARSENAME()
select OwnerAddress
from  PortfolioProjects..NashvilleHousing

select
PARSENAME(Replace(OwnerAddress, ',', '.'), 3),
PARSENAME(Replace(OwnerAddress, ',', '.'), 2),
PARSENAME(Replace(OwnerAddress, ',', '.'), 1)
from  PortfolioProjects..NashvilleHousing



Alter Table NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
Set OwnerSplitAddress = PARSENAME(Replace(OwnerAddress, ',', '.'), 3)



Alter Table NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
Set OwnerSplitCity = PARSENAME(Replace(OwnerAddress, ',', '.'), 2)



Alter Table NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
Set  OwnerSplitState = PARSENAME(Replace(OwnerAddress, ',', '.'), 1)


select *
from  PortfolioProjects..NashvilleHousing



--------------------------------------------------------------------------------------------

--Change Y and N to Yes and No in "Sold as Vacant" field

select Distinct(SoldAsVacant), count(SoldAsVacant)
from PortfolioProjects..NashvilleHousing
group by SoldAsVacant
order by 2


Select SoldAsVacant,
case when SoldAsVacant = 'Y' Then 'Yes'
     when SoldAsVacant = 'N' Then 'No'
	 Else SoldAsVacant
	 End
from PortfolioProjects..NashvilleHousing


Update NashvilleHousing
Set SoldAsVacant = case when SoldAsVacant = 'Y' Then 'Yes'
     when SoldAsVacant = 'N' Then 'No'
	 else SoldAsVacant
	 End


----------------------------------------------------------------------------------------------

--Remove Duplicates

With RowNumCTE as(
select *,
    ROW_NUMBER()OVER(
	Partition by ParcelID,
	             PropertyAddress,
				 SalePrice, 
				 SaleDate, 
				 LegalReference
				 Order by
				      UniqueID
					  ) row_num

from PortfolioProjects..NashvilleHousing
--order by ParcelID
)
Delete
from RowNumCTE
where row_num > 1
--order by PropertyAddress




------------------------------------------------------------------------------------------------

--Delete Unused Columns

select *
from PortfolioProjects..NashvilleHousing

Alter table PortfolioProjects..NashvilleHousing
drop column OwnerAddress, TaxDistrict, PropertyAddress


Alter table PortfolioProjects..NashvilleHousing
drop column SaleDate
