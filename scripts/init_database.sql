/*
Create the DataWarehouse database and different schemas: bronze, silver, and gold
Script purpose: 
	This script creates a new database called "DataWarehouse". If the database exists, it is dropped and recreated. Additionally,
	the script sets up three schemas within the database: 'bronze', 'silver', and 'gold'.

WARNING:
	Running this script will drop the entire 'DataWarehouse' database if it exists. All data
	in the database will be permanently deleted. Proceed with caution and ensure you have proper backups before running the script.
*/

-- Create database "DataWarehouse"
USE master;
GO

-- Drop and recreate the 'DataWarehouse' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
	ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE DataWarehouse;
END;
GO

CREATE DATABASE DataWarehouse;
GO
USE DataWarehouse;
GO

-- Create schemas
CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
GO