WITH gather_data AS (
  SELECT
    region_abrev,
    site_short,
    Contact_Id,
    hs_grad_year_c
  FROM
    `data-warehouse-289815.salesforce_clean.contact_template`
    WHERE college_track_status_c = '17A'
)

SELECT *
FROM gather_data