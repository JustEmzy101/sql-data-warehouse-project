--Create the db data_warehouse

/*
=====================================================
CREATE DATABASE AND SCHEMAS
=====================================================
Script purpose:
  This Script is used to check if the needed database exists with the same name or not. If it exists IT WILL DELETE IT and will create a new one.
  Additionally this script makes 3 schemas bronze,silver and gold " Following the medallion architecture ".
========
Warining 
  Running this script will delete any database with the existing name inside the script. PROCEED WITH CAUTION
========
*/
USE master; --standard choice before creating any database "How SQL works"
GO

IF EXISTS (SELECT 1 FROM sys.databases WHERE name= 'data_warehouse') -- checks wither this database exists or not
BEGIN
	ALTER DATABASE data_warehouse --Opening the database 
	SET SINGLE_USER --logging out any user so we alter the DB freely
	WITH ROLLBACK IMMEDIATE; --terminate any connection to the DB other than us
	DROP DATABASE data_warehouse -- delete the database itself
END;
GO

--Create Database 
CREATE DATABASE data_warehouse;
GO

--Set the database to multi-users
USE data_warehouse;
ALTER DATABASE data_warehouse SET MULTI_USER;

--Create schemas
CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
GO
