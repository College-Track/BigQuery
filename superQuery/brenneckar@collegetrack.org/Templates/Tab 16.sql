SELECT Contact_Id, most_recent_outreach, most_recent_reciprocal, latest_reciprocal_communication_date_c
FROM `data-warehouse-289815.salesforce_clean.contact_template`
WHERE most_recent_reciprocal IS NOT NULL
LIMIT 1000