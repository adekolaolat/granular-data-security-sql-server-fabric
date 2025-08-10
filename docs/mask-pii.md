# Granting access to stakeholders

The first step is to identify the fields that have PII, so I can apply the dynamic masking for the column. These fields will  be altered to mask  according to the type of masking needed.

| Fields |
| ------------- |
| Person.EmailAddress.EmailAddress|
| Person.PersonPhone.PhoneNumber |
| HumanResources.Employee.NationalIDNumber|
| Sales.CreditCard.CardNumber|

 Run the queries below to :

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


**Masked Email when logged in as an analyst**

![alt text](/images/masked_email.png)
