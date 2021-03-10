WITH gather_data AS (
  SELECT
    Contact_Id,
    site_short,
    region_short,
    CASE
      WHEN Prev_AT_Cum_GPA >= 3.25 THEN 1
      ELSE 0
    END AS above_325_gpa
  FROM
    `data-warehouse-289815.salesforce_clean.contact_at_template`
  WHERE
    current_as_c = true
)
SELECT
  region_short,
  site_short,
  AVG(above_325_gpa)
FROM
  gather_data
GROUP BY
  region_short,
  site_short