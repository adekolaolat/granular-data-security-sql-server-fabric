-- Create a login and password
CREATE LOGIN analyst_login WITH PASSWORD = 'Password123'

-- Create a User at database level
USE AdventureWorks2022;
GO

CREATE USER analyst_user FOR LOGIN analyst_login;
GO

-- Create a role
CREATE ROLE role_data_analyst;

GO
