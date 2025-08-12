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
WHERE @SalesEmail = USER_NAME() OR IS_ROLEMEMBER('sales_manager') = 1 OR USER_NAME() = 'dbo' -- I included dbo, so I can see the whole data as an admin.


GO

-- Use function to create policy!
CREATE SECURITY POLICY SalesQuotaFilter
ADD FILTER PREDICATE Security.fn_securitypredicate(Email) ON Sales.SalesQuotaFullDetails
WITH (STATE = ON)
GO

/*I didn’t include dbo in the security predicate at first, so the security policy ended up restricting my access as an admin.

I fixed that by :
Dropping the Security policy,
Alter the the predicate function
and re-created the Security policy.
*/

DROP SECURITY POLICY SalesQuotaFilter;
GO
-- -- Alter function
-- ALTER FUNCTION Security.fn_securitypredicate(
-- @SalesEmail AS nvarchar(50)
-- ) 
-- RETURNS TABLE
-- WITH SCHEMABINDING
-- AS
--     RETURN SELECT 1 AS fn_security_predicate_result
-- WHERE @SalesEmail = USER_NAME() OR IS_ROLEMEMBER('sales_manager') = 1 OR USER_NAME() = 'dbo' -- 
-- GO
-- -- Create policy
-- CREATE SECURITY POLICY SalesQuotaFilter
-- ADD FILTER PREDICATE Security.fn_securitypredicate(Email) ON Sales.SalesQuotaFullDetails
-- WITH (STATE = ON)
-- GO