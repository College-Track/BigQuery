SELECT 
Contact_Id,
`data-warehouse-289815.UDF.determine_buckets`(gpa_hs_cumulative_c,0.5, 2.5,3.0,'gpa')
FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
LIMIT 10