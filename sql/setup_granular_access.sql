
-- Create a login and password
CREATE LOGIN analyst WITH PASSWORD = 'Password123'

-- Create a User at database level
USE AdventureWorks2022;
GO

CREATE USER analyst FOR LOGIN analyst;
GO

-- Create a role
CREATE ROLE role_analyst;

GO

-- Add user to Roles

EXEC sp_addrolemember 'role_analyst','analyst';
GO

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


EXEC sp_add_advworks_user 'david8@adventure-works.com','david123','role_sales_rep';
GO

EXEC sp_add_advworks_user 'stephen0@adventure-works.com','stephen123','role_sales_rep';
GO

EXEC sp_add_advworks_user 'manager@adventure-works.com','manager123','role_sales_manager';
GO

ALTER TABLE Person.EmailAddress
ALTER COLUMN EmailAddress
ADD MASKED WITH (FUNCTION = 'email()');
GO

ALTER TABLE Person.PersonPhone  
ALTER COLUMN PhoneNumber  
ADD MASKED WITH (FUNCTION = 'partial(1,"XXX-XXXX-",4)');
GO

ALTER TABLE HumanResources.Employee  
ALTER COLUMN NationalIDNumber  
ADD MASKED WITH (FUNCTION = 'partial(0,"XXX-XXXX-",1)');
GO

-- Can only see last four digits
ALTER TABLE Sales.CreditCard
ALTER COLUMN CardNumber 
ADD MASKED WITH (FUNCTION = 'partial(0,"XXX-XXXX-",4)');
GO


-- Read all tables in Sales schema
GRANT SELECT ON SCHEMA::Sales TO role_data_analyst;
GO

-- Deny permision on CreditCard column (CLS)
DENY SELECT ON OBJECT::Sales.CreditCard(CardNumber) TO role_data_analyst;
GO
-- Give permission on the Employee table and deny on the NationalID Column
GRANT SELECT ON HumanResources.Employee TO role_data_analyst;
GO
-- Column-level security
DENY SELECT ON OBJECT::HumanResources.Employee(NationalIDNumber) TO role_data_analyst;
GO


SELECT
    p.BusinessEntityID AS id,
    CONCAT(p.FirstName,' ',p.LastName) AS Rep,
    em.EmailAddress AS Email,
    CONCAT('$',qh.SalesQuota) AS Quota,
    CAST(qh.QuotaDate AS DATE) AS QuotaDate
INTO Sales.SalesQuotaFullDetails -- New table
FROM Person.Person p
INNER JOIN HumanResources.Employee e ON p.BusinessEntityID = e.BusinessEntityID
INNER JOIN Sales.SalesPersonQuotaHistory qh ON qh.BusinessEntityID = p.BusinessEntityID
INNER JOIN Person.EmailAddress em ON em.BusinessEntityID = p.BusinessEntityID;
GO

GRANT SELECT ON OBJECT::Sales.SalesQuotaFullDetails TO role_analyst;
GO

GRANT SELECT ON OBJECT::Sales.SalesQuotaFullDetails TO role_sales_rep;
GO


DENY SELECT ON OBJECT::Sales.SalesQuotaFullDetails TO role_analyst;
GO

GRANT SELECT ON OBJECT::Sales.SalesQuotaFullDetails TO role_sales_rep;
GO

GRANT SELECT ON OBJECT::Sales.SalesQuotaFullDetails TO role_sales_manager;
GO

-- Implement Role level security (RLS)

-- Create a dedicated Schema named Security
CREATE SCHEMA Security;

GO

CREATE FUNCTION Security.fn_securitypredicate(
@SalesEmail AS nvarchar(50)
) 
RETURNS TABLE
WITH SCHEMABINDING
AS
    RETURN SELECT 1 AS fn_security_predicate_result
WHERE @SalesEmail = USER_NAME() OR IS_ROLEMEMBER('sales_manager') = 1 OR USER_NAME() = 'dbo' --I included dbo, so I can see the whole data as an admin.
GO

CREATE SECURITY POLICY SalesQuotaFilter
ADD FILTER PREDICATE Security.fn_securitypredicate(Email) ON Sales.SalesQuotaFullDetails
WITH (STATE = ON)
GO