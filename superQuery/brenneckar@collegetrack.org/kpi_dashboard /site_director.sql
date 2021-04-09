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
      WHEN (grade_c = '9th Grade'
      AND indicator_low_income_c = 'Yes'
      AND first_generation_fy_20_c = 'Yes') THEN 1
      ELSE 0
    END AS first_gen_and_low_income,
  FROM
    `data-warehouse-289815.salesforce_clean.contact_template`
  WHERE
    college_track_status_c = '11A'
)
-- SELECT 
-- *
-- FROM gather_hs_data
SELECT
  site_short,
  SUM(above_325_gpa) AS SD_senior_above_325,
  SUM(male_student) AS SD_ninth_grade_male,
  SUM(first_gen_and_low_income) AS SD_ninth_grade_first_gen_low_income,
  MAX(Account.College_Track_FY_HS_Planned_Enrollment_c) AS hs_budget_capacity
FROM
  gather_hs_data GSD
  LEFT JOIN `data-warehouse-289815.salesforce.account` Account ON Account.Id = GSD.site_c
  
GROUP BY
  site_short
  
  
  

  