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
    "National" AS national,
  region_short,
  site_short,
  SUM(above_325_gpa) AS above_325_gpa,
  COUNT(Contact_Id) AS student_count
FROM
  gather_data
GROUP BY
  region_short,
  site_short