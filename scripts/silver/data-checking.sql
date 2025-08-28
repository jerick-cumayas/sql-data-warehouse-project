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