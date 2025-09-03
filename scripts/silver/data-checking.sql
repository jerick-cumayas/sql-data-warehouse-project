/*
=================================================
DATA CLEANING: LOAD SILVER LAYER (BRONZE -> SILVER)
=================================================
Script purpose:
	This script performs various quality checks for data consistency, accuracy,
	and standardization across the silver schema. It includes checks for:
		- Null or duplicate primary keys
		- Unwanted spaces in string fields
		- Data standardization and consistency
		- Invalid date ranges and orders.
		- Data consistency between related fields.
*/

-- Check for nulls or duplicates in primary key of bronze.crm_cust_info
-- Expectation: No result
SELECT 
sls_ord_num,
COUNT(*) AS id_count
FROM bronze.crm_sales_details
GROUP BY sls_ord_num
HAVING COUNT(*) > 1 OR sls_ord_num IS NULL;

-- Check for unwanted spaces in string values
-- Expectation: No result
SELECT prd_nm FROM bronze.crm_prd_info WHERE prd_nm != TRIM(prd_nm);
SELECT cst_lastname FROM silver.crm_cust_info WHERE cst_lastname != TRIM(cst_lastname);
 
-- Check Data Standardization and Consistency
-- Expectation: No result
-- Gender Column
SELECT DISTINCT prd_line
FROM silver.crm_prd_info

-- Marital Status Column
SELECT DISTINCT(cst_marital_status)
FROM silver.crm_cust_info;

-- Check for Null values or negative numbers
-- Expectation: No results
SELECT prd_cost FROM bronze.crm_prd_info WHERE prd_cost < 0 or prd_cost IS NULL;

-- Check start and end date columns
-- Expectation: No results
SELECT * FROM silver.crm_prd_info WHERE prd_end_dt < prd_start_dt;

-- Check for Invalid Dates
SELECT 
NULLIF(sls_due_dt,0) AS sls_due_dt
FROM silver.crm_sales_details
WHERE 
sls_due_dt <= 0 OR 
len(sls_due_dt) != 8 OR 
sls_due_dt > 20500101 OR 
sls_due_dt < 19000101

-- Check for Invalid Date orders
SELECT 
*
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt

-- Check Sales, Quantity, Price
SELECT DISTINCT
sls_sales,
sls_quantity,
sls_price
FROM silver.crm_sales_details 
WHERE 
sls_sales IS NULL OR sls_quantity IS NULL or sls_price IS NULL OR
sls_sales <= 0 OR sls_quantity <= 0 or sls_price <= 0 OR
sls_sales != sls_quantity * sls_price
ORDER BY sls_sales, sls_quantity, sls_price

SELECT * FROM silver.crm_sales_details

-- Identify out-of-range dates
-- Bad data
SELECT DISTINCT
bdate 
FROM silver.erp_cust_az12
WHERE bdate < '1924-01-01' OR bdate > GETDATE()

-- Check gender values
SELECT DISTINCT gen FROM silver.erp_cust_az12;

-- Check cst_ids that are not in customer info
SELECT * FROM bronze.erp_loc_a101;
SELECT 
cst_key 
FROM silver.crm_cust_info
WHERE cst_key NOT IN (
	SELECT
	REPLACE(cid, '-', '') AS cid
	FROM bronze.erp_loc_a101
)

-- Data Standardization and Consistency
SELECT DISTINCT REPLACE(cid, '-', '') AS cid FROM bronze.erp_loc_a101;
SELECT DISTINCT cntry FROM silver.erp_loc_a101 ORDER BY cntry;
SELECT DISTINCT cntry FROM (
	SELECT
	REPLACE(cid, '-', '') AS cid,
	CASE 
		WHEN TRIM(cntry) IN ('USA', 'US', 'United States') THEN 'United States'
		WHEN TRIM(cntry) = 'DE' THEN 'Germany'
		WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
		ELSE TRIM(cntry)
	END AS cntry
	FROM bronze.erp_loc_a101
) AS sub;

-- Check for unwanted spaces
SELECT * 
FROM bronze.erp_px_cat_g1v2 
WHERE cat != TRIM(cat) OR subcat != TRIM(subcat) OR maintenance != TRIM(maintenance);

SELECT DISTINCT cat 
FROM bronze.erp_px_cat_g1v2

SELECT DISTINCT subcat 
FROM bronze.erp_px_cat_g1v2

SELECT DISTINCT maintenance 
FROM bronze.erp_px_cat_g1v2

-- Foreign key
SELECT *
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
WHERE c.customer_key IS NULL OR p.product_key IS NULL;