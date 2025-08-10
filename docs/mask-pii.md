# Granting access to stakeholders

The first step is to identify the fields that have PII that requires masking.

These fields should be modified to mask their data.

| Fields |
| ------------- |
| Person.EmailAddress.EmailAddress|
| Person.PersonPhone.PhoneNumber |
| HumanResources.Employee.NationalIDNumber|
| Sales.CreditCard.CardNumber|


#### Mask email address
```
ALTER TABLE Person.EmailAddress
ALTER COLUMN EmailAddress
ADD MASKED WITH (FUNCTION = 'email()');
GO

```

#### Mask phone number:

```
ALTER TABLE Person.PersonPhone  
ALTER COLUMN PhoneNumber  
ADD MASKED WITH (FUNCTION = 'partial(1,"XXX-XXXX-",4)');
```

#### Mask NationalID number
```
ALTER TABLE HumanResources.Employee  
ALTER COLUMN NationalIDNumber  
ADD MASKED WITH (FUNCTION = 'partial(0,"XXX-XXXX-",1)');
```

#### Mask CreditCard number
```
-- Can only see last four digits
ALTER TABLE Sales.CreditCard
ALTER COLUMN CardNumber 
ADD MASKED WITH (FUNCTION = 'partial(0,"XXX-XXXX-",4)');
```

### Outcome


**Masked Email whwn loged in as an analyst**
![alt text](/images/masked_email.png)
