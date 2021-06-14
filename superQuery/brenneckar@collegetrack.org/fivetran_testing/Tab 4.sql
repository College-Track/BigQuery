WITH gather_ay_attendance AS (
  SELECT
    site_short,
    contact_id,
    SUM(attended_workshops_c) AS attended_workshops_c,
    SUM(enrolled_sessions_c) AS enrolled_sessions_c
  FROM
    `data-warehouse-289815.salesforce_clean.contact_at_template`
  WHERE
    AY_Name = "AY 2020-21"
    AND site_short = 'Aurora'
  GROUP BY
    site_short,
    contact_id
),
prep_data AS (
  SELECT
  site_short,
  contact_Id,
    CASE
      WHEN enrolled_sessions_c = 0 THEN NULL
      WHEN (attended_workshops_c / enrolled_sessions_c) >= 0.8 THEN 1
      ELSE 0
    END AS above_80_attendance
  FROM
  gather_ay_attendance GAA 
  )

SELECT *
FROM prep_data