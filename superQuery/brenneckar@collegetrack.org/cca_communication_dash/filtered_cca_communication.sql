WITH gather_data AS(
SELECT Contact_Id, full_name_c,
FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
WHERE current_as_c = True AND college_track_status_c = '15A'
)

SELECT *
FROM gather_data
LIMIT 10