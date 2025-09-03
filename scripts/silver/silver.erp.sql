/*
========================================
DATA DEFINITION LANGUAGE
========================================
Script purpose:
	- Drops the ERP table if already present in DataWarehouse database
	- Creates a new table with defined columns and datatypes
	- This is for the silver layer
*/

IF OBJECT_ID('silver.erp_cust_az12', 'U') IS NOT NULL
    DROP TABLE silver.erp_cust_az12;
GO
CREATE TABLE silver.erp_cust_az12(
	cid NVARCHAR(50),
	bdate DATE,
	gen NVARCHAR(50),
	dwh_create_data DATETIME2 DEFAULT GETDATE()
);
GO
IF OBJECT_ID('silver.erp_loc_a101', 'U') IS NOT NULL
    DROP TABLE silver.erp_loc_a101;
GO
CREATE TABLE silver.erp_loc_a101(
	cid	NVARCHAR(50),
	cntry NVARCHAR(50),
	dwh_create_data DATETIME2 DEFAULT GETDATE()
);
GO
IF OBJECT_ID('silver.erp_px_cat_g1v2', 'U') IS NOT NULL
    DROP TABLE silver.erp_px_cat_g1v2;
GO
CREATE TABLE silver.erp_px_cat_g1v2(
	id NVARCHAR(50),
	cat NVARCHAR(50),
	subcat NVARCHAR(50),
	maintenance NVARCHAR(50),
	dwh_create_data DATETIME2 DEFAULT GETDATE()
);