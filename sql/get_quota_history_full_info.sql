
-- Get history list of quotas for Sales rep including names and email
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
