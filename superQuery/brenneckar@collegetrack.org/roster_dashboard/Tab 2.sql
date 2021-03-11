SELECT COUNT(Contact_Id)
FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
GROUP BY Contact_Id
WHERE  current_as_c = true
Having COUNT(Contact_Id) > 1