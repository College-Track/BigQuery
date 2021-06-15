WITH gather_ay_attendance AS (
  SELECT
    site_short,
    contact_id,
    GAS_Name,
    SUM(attended_workshops_c) AS attended_workshops_c,
    SUM(enrolled_sessions_c) AS enrolled_sessions_c
  FROM
    `data-warehouse-289815.salesforce_clean.contact_at_template`
  WHERE
    AY_Name = "AY 2020-21"
    AND site_short = 'Aurora'
    AND college_track_status_c = '11A'
  GROUP BY
    site_short,
    GAS_Name,
    contact_id
),
prep_data AS (
  SELECT
  site_short,
  contact_Id,
     GAS_Name,
  attended_workshops_c,
  enrolled_sessions_c,

    CASE
      WHEN enrolled_sessions_c = 0 THEN NULL
      WHEN (attended_workshops_c / enrolled_sessions_c) >= 0.8 THEN 1
      ELSE 0
    END AS above_80_attendance
  FROM
  gather_ay_attendance GAA 
  )

-- SELECT site_short, SUM(above_80_attendance), COUNT(Contact_Id)
-- FROM prep_data
-- GROUP BY site_short

SELECT SUM(attended_workshops_c), SUM(enrolled_sessions_c), SUM(above_80_attendance)
FROM prep_data
GROUP BY GAS_Name