
-- Apply Dynamic Data Masking to email column
ALTER TABLE Person.EmailAddress
ALTER COLUMN EmailAddress
ADD MASKED WITH (FUNCTION = 'email()');
GO

-- Apply DDM to Phone
ALTER TABLE Person.PersonPhone  
ALTER COLUMN PhoneNumber  
ADD MASKED WITH (FUNCTION = 'partial(1,"XXX-XXXX-",4)');
GO

-- Apply  DDM to National ID
ALTER TABLE HumanResources.Employee  
ALTER COLUMN NationalIDNumber  
ADD MASKED WITH (FUNCTION = 'partial(0,"XXX-XXXX-",1)');

-- Can only see last four digits
ALTER TABLE Sales.CreditCard
ALTER COLUMN CardNumber 
ADD MASKED WITH (FUNCTION = 'partial(0,"XXX-XXXX-",4)');


