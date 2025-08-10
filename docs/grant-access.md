# Granting access to stakeholders

This section will set up Object-Level Permissions and Column-Level Security (CLS) for the analyst , sales rep and sales manager, and also cover potential issues that could cause you to lose the masking security on an originally masked column leading to implementation of RLS.

## Access for analyst

For analyst, we grant access to the 

| Requirements |
| ------------- |
| Read All Tables in Sales|
| Mask PII any PII informations|
| Should not be able to access NationalIDNumber column in Employee table, but have access to others|


Run this query to grant/deny the required permissions to the analyst:
```
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

```

Connect to database as an analyst and run this query:

```
SELECT
    p.BusinessEntityID AS id,
    CONCAT(p.FirstName,' ',p.LastName) As Sales_Person,
    em.EmailAddress AS Email,
    CONCAT('$',qh.SalesQuota) AS Quota,
    CAST(qh.QuotaDate AS DATE) AS QuotaDate
FROM Person.Person p
INNER JOIN HumanResources.Employee e ON p.BusinessEntityID = e.BusinessEntityID
INNER JOIN Sales.SalesPersonQuotaHistory qh ON qh.BusinessEntityID = p.BusinessEntityID
INNER JOIN Person.EmailAddress em ON em.BusinessEntityID = p.BusinessEntityID;

GO
```
Now, the email address is masked and including the NationalIDNumber column would make the query fail. Running any query that includes any masked column will be masked for the analyst.

Now, run this query as admin. Running this query as the analyst would fail, as the analyst has no CREATE TABLE permission.

```
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
```

The query creates a new transformed table called **SalesQuotaFullDetails** that shows quota information for each sales representatives.

If you try to login as an analyst and run a SELECT statement on the table, this fails because the analyst has no permission yet.

So, on the admin side, we need to give permission to read the **SalesQuotaFullDetails** table to the analyst and sales rep by running this query:

```
GRANT SELECT ON OBJECT::Sales.SalesQuotaFullDetails TO role_analyst;
GO

GRANT SELECT ON OBJECT::Sales.SalesQuotaFullDetails TO role_sales_rep;
GO
```

Now the analyst and sales reps can query the table with SELECT statements, but there’s a problem:

- The **analyst** can see unmasked data. That’s not what we want. The analyst shouldn’t have access to this table at all.
  
- **Sales reps** should only see their own rows. It’s fine for a sales rep to see their own email. The fix is would be to remove the analyst’s permissions for this table, then use Row-Level Security  to make sure sales reps only see their own data.


## Access for Sales rep and Sales manager
| Requirements |
| ------------- |
| Read **Sales.SalesQuotaFullDetails** table||
| Sales rep sees only their rows, Manager and Admin can see all|


Run this to deny the analyst and grant sales reps access to the **SalesQuotaFullDetails**:
```
DENY SELECT ON OBJECT::Sales.SalesQuotaFullDetails TO role_analyst;
GO

GRANT SELECT ON OBJECT::Sales.SalesQuotaFullDetails TO role_sales_rep;
GO

GRANT SELECT ON OBJECT::Sales.SalesQuotaFullDetails TO role_sales_manager;
GO
```

If you log in as one of the sales rep, you will be able to access and see all data from the table.

Now, I'll implement the row-level security for the **SalesQuotaFullDetails** table to prevent this.

[Implement Row-Level Security]()


