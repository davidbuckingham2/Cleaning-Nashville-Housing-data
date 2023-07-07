# Data Cleaning in SQL using Nashville Housing Data
This GitHub repository contains a project focused on cleaning data in SQL using the Nashville Housing dataset. The project includes several data cleaning tasks performed on the dataset.

## Data Cleaning Tasks
### Standardize Date Format
Standardized the date format in the SaleDate column to ensure consistency and compatibility.

### Populate Property Address Data
Populated missing property addresses by matching records with the same ParcelID and updating the missing PropertyAddress with a valid address from another record with the same ParcelID.
### Breaking out Address into Individual Columns
- Split the PropertyAddress column into separate columns such as Address, City, and State for more granular address information.

- Separated the components of the OwnerAddress column into distinct columns such as OwnerSplitAddress, OwnerSplitCity, and OwnerSplitState.

### Change 'Y' and 'N' to 'Yes' and 'No' in "Sold as Vacant" Field
Modified the values in the SoldAsVacant field, replacing 'Y' with 'Yes' and 'N' with 'No' to enhance readability and consistency.
### Remove Duplicates
Removed duplicate entries from the dataset based on specific columns (ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference).
### Delete Unused Columns
Removed unused columns (OwnerAddress, TaxDistrict, PropertyAddress, SaleDate) from the dataset to streamline the data structure.



Please refer to the project files for more detailed information on each data cleaning task and the specific SQL operations performed.
