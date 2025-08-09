-- Create new table for quotas history for Sales rep including names and email

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
