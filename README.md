

# Data Governance: Implementing Granular Access Control



## Overview & Scenario

This project implements data governance at a granular level by applying features such as Dynamic Data Masking (DDM), Column-Level Security (CLS), and Row-Level Security (RLS) within a business setting.

This is demonstrated using SQL Server but also applies to SQL Endpoints and Data Warehouse on Fabric and Synapse


  <details><summary><b> Scenario</b></summary>
Let's say . . .

A business  has an Information Governance (IG) policy, with data governance as a core component that requires protecting client and employee PII. Also, an analyst needs to some historical sales quota data for analysis, but raw data contains sensitive fields. The sales manager wants the sales reps to see only their own quotas when they access this.

The management has asked that this adheres the organization's IG.


**Requirements** and **Solutions** would include: 

- Access to data must follow the **principle of least privilege** and regulatory compliance.

- Identify necessary tables so we can restrict or mask PII.

- Use **Column-Level Security (CLS)** and **Dynamic Data Masking(DDM** to hide sensitive fields from analyst.

- Apply **Row-Level Security (RLS)** so sales reps see only their data; managers and database admin can see all.

- Restrict tables or schemas not needed by the stakeholders with Object-Level Security.

  </details>

## Prerequisite

- Adventure Works database set up on SQL server/ Fabric Data Warehouse, SQL Endpoints/ Synapse. Check [here](https://github.com/adekolaolat/fabric-data-engineering-on-premises-db/blob/main/guides/on-prem-db-setup.md) for set up SQL Server on local machine.
- T-SQL  

## Data governance overview

## Implementation Steps

- [Set up  on-prem DB and Fabric](https://github.com/adekolaolat/fabric-data-engineering-on-premises-db/blob/main/guides/on-prem-db-setup.md)
  <details><summary>Set up</summary>

  - SQL Server, SSMS
  - Restore AdventureWorks database
  - Enable Remote Connections to SQL Server
  - Set up on-premises DB on machine

  </details>

  - (Optional) [Data pipeline to land data from  on-premises into Fabric lakehouse.](https://github.com/adekolaolat/fabric-data-engineering-on-premises-db/blob/main/guides/data-ingestion.md)

- [Create access (logins) for stakeholders](https://github.com/adekolaolat/granular-data-security-sql-server-fabric/blob/main/docs/create-db-access.md)
- [Dynamic data masking of PII](https://github.com/adekolaolat/granular-data-security-sql-server-fabric/blob/main/docs/mask-pii.md).
- [Grant permissions to required tables for stakeholders: Object-level security and Column-level security](https://github.com/adekolaolat/granular-data-security-sql-server-fabric/blob/main/docs/grant-access.md)
- [Implement row-level security to table](https://github.com/adekolaolat/granular-data-security-sql-server-fabric/blob/main/docs/implement-rls.md).
  
## Final Thoughts

The security side of data governance is about making sure information is kept safe and used responsibly in the organization. Granular security features like DDM, CLS, and RLS in on-prem databases and data warehouses are what turn these rules into reality. 

By controlling exactly who can see what data and how much detail they get, these features help follow governance policies, keep sensitive information like PII safe, and make the policies something you can actually enforce.
