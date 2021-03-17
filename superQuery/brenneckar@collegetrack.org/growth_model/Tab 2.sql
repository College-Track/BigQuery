SELECT 
Contact_Id,
`data-warehouse-289815.UDF.determine_buckets`(AT_Cumulative_GPA,0.5, 2.5,3.0,'gpa')
FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
WHERE AT_Cumulative_GPA IS NOT NULL
LIMIT 10