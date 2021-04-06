WITH gather_data AS (
  SELECT
    Contact_Id,
    site_short,
    CASE
      WHEN Prev_AT_Cum_GPA >= 3.25 THEN 1
      ELSE 0
    END AS above_325_gpa,
        CASE
      WHEN composite_readiness_most_recent_c = '1. Ready' THEN 1
      ELSE 0
    END AS composite_ready
    
  FROM
    `data-warehouse-289815.salesforce_clean.contact_at_template`
  WHERE
    current_as_c = true AND college_track_status_c IN ('11A')
)
SELECT

  site_short,
  SUM(above_325_gpa) AS above_325_gpa,
  SUM(composite_ready) AS composite_ready,
FROM
  gather_data
GROUP BY
  site_short