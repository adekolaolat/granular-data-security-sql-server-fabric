-- Stored procedure to create User

CREATE PROCEDURE sp_add_advworks_user(
    @loginName sysname,
    @password  nvarchar(128),
    @userName  sysname,
    @roleName  sysname
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Create Login in master
    DECLARE @sql nvarchar(max);

    SET @sql = N'CREATE LOGIN ' + QUOTENAME(@loginName) +
               N' WITH PASSWORD = ' + QUOTENAME(@password,'''');
    EXEC master.sys.sp_executesql @sql;

    -- Create User in AdventureWorks2022
    SET @sql = N'USE AdventureWorks2022;
                 CREATE USER ' + QUOTENAME(@userName) +
                 N' FOR LOGIN ' + QUOTENAME(@loginName) + ';';
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