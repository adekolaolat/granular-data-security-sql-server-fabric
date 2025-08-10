# Creating access to DB

You must be at an admin level to have permission to run this.

First, is to create access to the database for the stakeholders. 

## Create access for stakeholders

Run this to create credentials required to access the database using SQL Authentication for the analyst.

```
-- Create a login and password
CREATE LOGIN analyst WITH PASSWORD = 'Password123'

-- Create a User at database level
USE AdventureWorks2022;
GO

CREATE USER analyst FOR LOGIN analyst;
GO

-- Create a role
CREATE ROLE data_analyst;

GO
```

I've also written a stored procedure to make it easier to set up access for stakeholders, and use it to test the security scenarios..

Run the query to create the stored procedure:

```
-- Stored procedure to create User

CREATE PROCEDURE sp_add_advworks_user(
    @userName sysname,
    @password  nvarchar(128),
    @roleName  sysname
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Create Login in master
    DECLARE @sql nvarchar(max);

    SET @sql = N'CREATE LOGIN ' + QUOTENAME(@userName) +
               N' WITH PASSWORD = ' + QUOTENAME(@password,'''');
    EXEC master.sys.sp_executesql @sql;

    -- Create User in AdventureWorks2022
    SET @sql = N'USE AdventureWorks2022;
                 CREATE USER ' + QUOTENAME(@userName) +
                 N' FOR LOGIN ' + QUOTENAME(@userName) + ';';
    EXEC master.sys.sp_executesql @sql;

    -- Create Role if not exists
    SET @sql = N'USE AdventureWorks2022;
                 IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = ' + QUOTENAME(@roleName,'''') + ')
                 CREATE ROLE ' + QUOTENAME(@roleName) + ';';
    EXEC master.sys.sp_executesql @sql;

    -- Add User to Role
    SET @sql = N'USE AdventureWorks2022;
                 EXEC sp_addrolemember ' + QUOTENAME(@roleName,'''') + ', ' + QUOTENAME(@userName,'''') + ';';
    EXEC master.sys.sp_executesql @sql;
END
GO

```

And then run the  EXEC statements to create access to the database for sales manage and sales rep.

```

EXEC sp_add_advworks_user 'david8@adventure-works.com','david123','role_sales_rep';
GO

EXEC sp_add_advworks_user 'stephen0@adventure-works.com','stephen123','role_sales_rep';
GO

EXEC sp_add_advworks_user 'manager@adventure-works.com','manager123','sales_manager';
GO

```

Currently, the users (stakeholders) has no permissions in the AdventureWorks2022 database, which can be confirmed by attempting to log in as any of the created users.

Permissions required to run any query (read or write) will be granted gradually by the administrator, based solely on the user’s specific needs. **This approach ensures compliance with the principle of least privilege**.

In Fabric/Synapse you would typically create new tenant user in the Azure portal.