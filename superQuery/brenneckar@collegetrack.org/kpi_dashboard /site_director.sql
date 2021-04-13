WITH gather_hs_data AS (
  SELECT
    Contact_Id,
    site_short,
    site_c,
    CASE
      WHEN grade_c = '12th Grade'
      AND Prev_AT_Cum_GPA >= 3.25 THEN 1
      ELSE 0
    END AS above_325_gpa,
    CASE
      WHEN grade_c = '9th Grade'
      AND Gender_c = 'Male' THEN 1
      ELSE 0
    END as male_student,
    CASE
      WHEN (
        grade_c = '9th Grade'
        AND indicator_low_income_c = 'Yes'
        AND first_generation_fy_20_c = 'Yes'
      ) THEN 1
      ELSE 0
    END AS first_gen_and_low_income,
    CASE
      WHEN summer_experiences_previous_summer_c > 0 THEN 1
      ELSE 0
    END AS summer_experience
  FROM
    `data-warehouse-289815.salesforce_clean.contact_template`
  WHERE
    college_track_status_c = '11A'
),
gather_ps_data AS (
  SELECT
    Contact_Id,
    site_short,
    site_c,
    CASE
      WHEN (
        Credit_Accumulation_Pace_c != "6+ Years"
        AND Current_Enrollment_Status_c = "Full-time"
      ) THEN 1
      ELSE 0
    END AS on_track
  FROM
    `data-warehouse-289815.salesforce_clean.contact_template`
  WHERE
    college_track_status_c = '15A'
),
gather_ay_attendance AS (
  SELECT
    Contact_Id,
    SUM(attended_workshops_c) AS attended_workshops_c,
    SUM(enrolled_sessions_c) AS enrolled_sessions_c
  FROM
    `data-warehouse-289815.salesforce_clean.contact_at_template`
  WHERE
    AY_Name = "AY 2020-21"
  GROUP BY
    Contact_Id
),
join_hs_data AS (
  SELECT
    GHSD.*,
    CASE
      WHEN enrolled_sessions_c = 0 THEN NULL
      WHEN (attended_workshops_c / enrolled_sessions_c) > 0.8 THEN 1
      ELSE 0
    END AS above_80_attendance
  FROM
    gather_hs_data GHSD
    LEFT JOIN gather_ay_attendance GAA ON GAA.Contact_Id = GHSD.Contact_Id
),
prep_hs_metrics AS (
  SELECT
    GSD.site_short,
    SUM(above_325_gpa) AS SD_senior_above_325,
    SUM(male_student) AS SD_ninth_grade_male,
    SUM(first_gen_and_low_income) AS SD_ninth_grade_first_gen_low_income,
    SUM(above_80_attendance) AS SD_above_80_attendance,
    SUM(summer_experience) AS SD_summer_experience,
    MAX(Account.College_Track_FY_HS_Planned_Enrollment_c) AS hs_budget_capacity,
  FROM
    join_hs_data GSD
    LEFT JOIN `data-warehouse-289815.salesforce.account` Account ON Account.Id = GSD.site_c
  GROUP BY
    site_short
),
prep_ps_metrics AS (
  SELECT
    site_short,
    SUM(on_track) AS SD_on_track
  FROM
    gather_ps_data
  GROUP BY
    site_short
)
SELECT
  HS_Data.*,
  PS_Data.*
EXCEPT(site_short)
FROM
  join_hs_data HS_Data
  LEFT JOIN prep_ps_metrics PS_Data ON PS_Data.site_short = HS_Data.site_short