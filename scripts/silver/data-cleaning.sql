-- Data Cleaning 

-- Remove null or duplicates in primary key
-- Duplicates in primary key are ranked by date creation.
-- In order to remove null or duplicates, we extract first in rank or 
-- row that is latest.
SELECT
* 
FROM (
	SELECT 
	*,
	ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS rank_by_date
	FROM bronze.crm_cust_info
) t WHERE rank_by_date = 1;

-- Remove leading and trailing spaces in columns cst_firstname and cst_lastname
-- TRIM cst_firstname and cst_lastname
SELECT 
cst_id,
cst_key,
TRIM(cst_firstname) AS cst_firstname,
TRIM(cst_lastname) AS cst_lastname,
cst_marital_status,
cst_gndr,
cst_create_date
FROM 
bronze.crm_cust_info;

-- Remove abbreviations in marital status and gender columns
-- Conver S and M to Single and Married
-- Convert M and F to Male and Female
SELECT 
cst_id,
cst_key, 
cst_firstname,
cst_lastname,
CASE 
	WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
	WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
	ELSE 'n/a'
END cst_marital_status,
CASE 
	WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
	WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
	ELSE 'n/a'
END cst_gndr,
cst_create_date
FROM bronze.crm_cust_info;

-- FULL CODE DATA CLEANSING
SELECT 
cst_id,
cst_key,
TRIM(cst_firstname) AS cst_firstname,
TRIM(cst_lastname) AS cst_lastname,
CASE 
	WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
	WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
	ELSE 'n/a'
END AS cst_marital_status,
CASE 
	WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
	WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
	ELSE 'n/a'
END AS cst_gndr,
cst_create_date
FROM (
	SELECT
	*,
	ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS rank_by_date
	FROM bronze.crm_cust_info
)t WHERE rank_by_date = 1;

-- INSERT INTO silver layer table
TRUNCATE TABLE silver.crm_cust_info;
INSERT INTO silver.crm_cust_info (
	cst_id,
	cst_key,
	cst_firstname,
	cst_lastname,
	cst_marital_status,
	cst_gndr,
	cst_create_date
) 
SELECT 
cst_id,
cst_key,
TRIM(cst_firstname) AS cst_firstname,
TRIM(cst_lastname) AS cst_lastname,
CASE 
	WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
	WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
	ELSE 'n/a'
END AS cst_marital_status,
CASE 
	WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
	WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
	ELSE 'n/a'
END AS cst_gndr,
cst_create_date
FROM (
	SELECT
	*,
	ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS rank_by_date
	FROM bronze.crm_cust_info WHERE cst_id IS NOT NULL
)t WHERE rank_by_date = 1;


--------------

SELECT * FROM bronze.crm_prd_info;

SELECT DISTINCT(prd_line) FROM bronze.crm_prd_info;

SELECT sls_prd_key FROM bronze.crm_sales_details;

SELECT 
prd_id, 
prd_key, 
prd_nm, 
prd_start_dt,
prd_end_dt,
LEAD (prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)-1 AS prd_end_dt_test
FROM bronze.crm_prd_info
WHERE prd_key in ('AC-HE-HL-U509-R');

SELECT 
prd_id,
prd_key,
REPLACE(SUBSTRING(prd_key, 1, 5), '-','_') AS cat_id,
SUBSTRING(prd_key, 7, LEN(prd_key) - 6) AS prd_key,
prd_nm, 
ISNULL(prd_cost, 0) AS prd_cost,
CASE UPPER(TRIM(prd_line))
	WHEN 'M' THEN 'Mountain'
	WHEN 'R' THEN 'Road'
	WHEN 'S' THEN 'Other Sales'
	WHEN 'T' THEN 'Touring'
	ELSE 'n/a'
END AS prd_line,
CAST(prd_start_dt AS DATE) AS prd_start_dt,
CAST(LEAD (prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)-1 AS DATE) AS prd_end_dt
FROM bronze.crm_prd_info;

INSERT INTO silver.crm_prd_info (
	prd_id,
	cat_id,
	prd_key,
	prd_nm,
	prd_cost,
	prd_line,
	prd_start_dt,
	prd_end_dt
)
SELECT 
prd_id,
REPLACE(SUBSTRING(prd_key, 1, 5), '-','_') AS cat_id,
SUBSTRING(prd_key, 7, LEN(prd_key) - 6) AS prd_key,
prd_nm, 
ISNULL(prd_cost, 0) AS prd_cost,
CASE UPPER(TRIM(prd_line))
	WHEN 'M' THEN 'Mountain'
	WHEN 'R' THEN 'Road'
	WHEN 'S' THEN 'Other Sales'
	WHEN 'T' THEN 'Touring'
	ELSE 'n/a'
END AS prd_line,
CAST(prd_start_dt AS DATE) AS prd_start_dt,
CAST(LEAD (prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)-1 AS DATE) AS prd_end_dt
FROM bronze.crm_prd_info;