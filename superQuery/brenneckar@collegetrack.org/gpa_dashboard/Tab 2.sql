SELECT
  Contact_Id,
  AT_Cumulative_GPA_bucket
  
FROM
  `data-warehouse-289815.salesforce_clean.contact_at_template`
WHERE term_c = 'Spring'  AND grade_c = '9th Grade' AND AT_Cumulative_GPA IS NOT NULL

LIMIT 1000