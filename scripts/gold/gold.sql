-- CHECKING DUPLICATES
SELECT cst_id, COUNT(*) 
FROM (
SELECT
ci.cst_id,
ci.cst_key,
ci.cst_firstname,
ci.cst_lastname,
ci.cst_marital_status,
ci.cst_gndr,
ci.cst_create_date,
ca.bdate,
ca.gen,
la.cntry
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
ON	ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
ON ci.cst_key = la.cid
)t GROUP BY cst_id HAVING COUNT(*) > 1

SELECT DISTINCT
ci.cst_gndr,
ca.gen,
CASE 
	WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr
	ELSE COALESCE(ca.gen, 'n/a')
END AS new_gndr
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
ON	ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
ON ci.cst_key = la.cid
ORDER BY 1,2

-- FOR CUSTOMER VIEW
SELECT
ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key,
ci.cst_id AS customer_id,
ci.cst_key AS customer_number,
ci.cst_firstname AS first_name,
ci.cst_lastname AS last_name,
la.cntry AS country,
ci.cst_marital_status AS marital_status,
CASE 
	WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr
	ELSE COALESCE(ca.gen, 'n/a')
END AS gender,
ca.bdate AS birthdate,
ci.cst_create_date AS create_date
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
ON	ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
ON ci.cst_key = la.cid

-- FOR PRODUCT VIEW
SELECT prd_key, COUNT(*) FROM(
SELECT 
prd.prd_id,
prd.cat_id,
prd.prd_key,
prd.prd_nm,
prd.prd_cost,
prd.prd_line,
prd.prd_start_dt,
px.cat,
px.subcat,
px.maintenance
FROM silver.crm_prd_info prd
LEFT JOIN silver.erp_px_cat_g1v2 px
ON prd.cat_id = px.id
WHERE prd.prd_end_dt IS NULL
)t GROUP BY prd_key HAVING COUNT(*) > 1;

SELECT 
ROW_NUMBER() OVER (ORDER BY prd.prd_start_dt, prd.prd_key) AS product_key,
prd.prd_id AS product_id,
prd.prd_key AS product_key,
prd.prd_nm AS product_name,
prd.cat_id AS category_id,
px.cat AS category,
px.subcat AS subcategory,
px.maintenance,
prd.prd_cost AS cost,
prd.prd_line AS product_line,
prd.prd_start_dt AS start_date
FROM silver.crm_prd_info prd
LEFT JOIN silver.erp_px_cat_g1v2 px
ON prd.cat_id = px.id
WHERE prd.prd_end_dt IS NULL

-- FOR SALES
SELECT
sls_ord_num AS order_number,
pr.product_key,
cu.customer_key,
sls_order_dt AS order_date,
sls_ship_dt AS shipping_date,
sls_due_dt AS due_date,
sls_sales AS sales_amount,
sls_quantity AS quantity,
sls_price AS price
FROM silver.crm_sales_details sd
LEFT JOIN gold.dim_products pr
ON sd.sls_prd_key = pr.product_number
LEFT JOIN gold.dim_customers cu
ON sd.sls_cust_id = cu.customer_id

SELECT * FROM gold.fact_sales
