/*
==========================

Create a Database and Schemas

==========================

Script Purpose:
	This script creates a new database named 'CustomerBehavior' after checking if it already exists.
	If the database exists, it is going to be dropped and recreated.
	Script also sets up three schemas; bronze, silver and gold.

WARNING:
	Running this script will drop the entire 'CustomerBehavior' database if it exists.
	All data in the database will be permanently deleted. Proceed with caution and ensure
	you have proper backups before running this script.
*/

USE master;
GO

-- Drop and recerate the 'CustomerBehavior' database
IF EXISTS (SELECT * FROM sys.databases WHERE name = 'CustomerBehavior')
BEGIN
	ALTER DATABASE CustomerBehavior SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE CustomerBehavior;
END;
GO

-- Create the 'CustomerBehavior' database
CREATE DATABASE CustomerBehavior;
GO

USE CustomerBehavior;
GO

CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO
