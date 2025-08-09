
-- EXEC sp_EXEC sp_add_advworks_user "@userName, @password,@roleName

-- Create analyst User
EXEC sp_add_advworks_user 'analyst','analyst123','role_analyst';
GO

GRANT SELECT ON SCHEMA::Sales TO role_data_analyst;


-- Apply Column Level Security On national IDs
GRANT SELECT ON HumanResources.Employee TO role_data_analyst;
GO
DENY SELECT ON OBJECT::HumanResources.Employee(NationalIDNumber) TO role_data_analyst;
GO

-- Apply Column level security on CreditCard numbers

GRANT SELECT ON  TO role_data_analyst;
GO
DENY SELECT ON OBJECT:: TO role_data_analyst;
GO



-- USERS to test row-security
EXEC sp_add_advworks_user 'david8@adventure-works.com','david123','role_sales_rep';

EXEC sp_add_advworks_user 'stephen0@adventure-works.com','david123','role_sales_rep';


-- For Fabric, one can create another Fabric tenant on Azure portal to test this.