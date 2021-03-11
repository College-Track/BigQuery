SELECT COUNT(Contact_Id)
FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
WHERE  current_as_c = true

GROUP BY Contact_Id
Having COUNT(Contact_Id) > 1