# Implement the Row-level Security


For the **Sales.SalesQuotaFullDetails** table :

- Sales manager and admins should be able to see all data on this table
  
- Sales rep should only see their own quota history.

To implement this, I'll need to:

- Create a function for my filter predicate based on the user/ role.
  
- And then create a Security policy on the **SalesQuotaFullDetails** table

Implementation of 

```
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
WHERE @SalesEmail = USER_NAME() OR USER_NAME() = 'dbo' -- I included dbo, so I can see the whole data as an admin.


GO
```