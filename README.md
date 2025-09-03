# sql-data-warehouse-project
a repository of my implementation of a data warehouse project. it follows the implementation of a data warehouse from Sir Baraa. link to his repository: https://github.com/DataWithBaraa/sql-data-warehouse-project

# Progress
- [x] Create database "DataWarehouse"
- [x] Create schemas for the different layers: bronze, silver and gold
- [x] Build the Bronze layer 
    - [x] Analysing: Source Systems
    - [x] Coding: Data Ingestion
    - [x] Validating: Data Completeness and Schema Checks
    - [x] Bronze Layer - Data Flow
    - [x] Commit Code in Git Repo
- [x] Build the Silver layer
    - [x] Explore and understand the data
    - [x] Build the DDL for Silver layer
    - [x] Clean and load the customer_info
        1. [x] Replace gender abbreviation to words
        2. [x] Replace marital status abbreviation to words
    - [x] Clean and load the crm_prd_info 
		1. [x] Check null or duplicates of primary key - prd_id
		2. [x] Separate category id and product id
		3. [x] Replace product cost Null values to zero(0)
		4. [x] Replace abbreviations in product line to actual words
		5. [x] Cast datetime to date 
		6. [x] Make end date of the previous row equivalent to the start date of next row minus one (next row date - 1)
    - [x] Clean and load the sales_details
        1. [x] Cast integer dates into actual date
        2. [x] Replaced null or empty sales to have quantiy multiplied by price
        3. [x] Check price, quantity, and sales
    - [x] Clean and load ERP_CUST from SQL Datawarehouse tutorial
    - [x] Clean and load ERP_LOC from SQL Datawarehouse tutorial
    - [x] Clean and load ERP_PX from SQL Datawarehouse tutorial
- [x] Build the Gold layer
    - [x] Understand data modeling
    - [x] Difference between Star schema and Snowflake schema
    - [x] Difference between Dimension and Facts
    - [x] Create dimension customers
    - [x] Create dimension products
    - [x] Create fact sales