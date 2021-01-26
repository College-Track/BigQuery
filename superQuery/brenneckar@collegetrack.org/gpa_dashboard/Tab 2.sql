SELECT
  Contact_Id,
  AT_Cumulative_GPA_bucket
  
FROM
  `data-warehouse-289815.salesforce_clean.contact_at_template`
WHERE term_c = 'Spring' 
LIMIT 1000