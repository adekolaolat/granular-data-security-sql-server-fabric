# Implement the Row-level Security


For the **Sales.SalesQuotaFullDetails** table :

- Sales manager and admins should be able to see all data on this table
  
- Sales rep should only see their own quota history.

To implement this, I'll need to:

- Create a function for my filter predicate based on the user/ role.
  
- And then create a Security policy on the **SalesQuotaFullDetails** table

Run this query to create the Function to filter users or ignore it base on the role:

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
WHERE @SalesEmail = USER_NAME() OR IS_ROLEMEMBER('sales_manager') = 1 OR USER_NAME() = 'dbo' --I included dbo, so I can see the whole data as an admin.
GO
```

Now, run this to create the Security policy on **SalesQuotaFullDetails** table:

```
CREATE SECURITY POLICY SalesQuotaFilter
ADD FILTER PREDICATE Security.fn_securitypredicate(Email) ON Sales.SalesQuotaFullDetails
WITH (STATE = ON)
GO
```

Now run this query as an admin:
```
SELECT * FROM [AdventureWorks2022].[Sales].[SalesQuotaFullDetails]
ORDER BY Rep, CAST(QuotaDate AS Date) ASC;

```
You should get the all the records as an admin or when logged in as the sales manager.

![alt text](/images/rls_adm_man.png)



Now, log in as one of the sales rep, you can only see that sales rep's record.

### Outcome

This is the result when you run the same query as *'stephen0@adventure-works.com'*, a sales rep after implementation of RLS. *'stephen0@adventure-works.com'* can only see his data:

![alt text](/images/rls_stephen.png)




