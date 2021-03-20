WITH gather_data AS (
  SELECT
    region_abrev,
    site_short,
    Contact_Id
  FROM
    `data-warehouse-289815.salesforce_clean.contact_template`
    WHERE college_track_status_c = '17A'
)

SELECT COUNT(contact_Id)
FROM gather_data