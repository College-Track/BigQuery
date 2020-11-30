WITH gather_data AS (
SELECT Contact_Id
FROM `data-warehouse-289815.salesforce_clean.contact_template`
WHERE college_track_status_c IN ('11A')

)

SELECT *
FROM gather_data