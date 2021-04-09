WITH gather_hs_data AS (
  SELECT
    Contact_Id,
    site_short,
    CASE
      WHEN grade_c = 'Senior'
      AND Prev_AT_Cum_GPA >= 3.25 THEN 1
      ELSE 0
    END AS above_325_gpa,
    CASE
      WHEN grade_c = ' Freshman'
      AND Gender_c = 'Male' THEN 1
      ELSE 0
    END as male_student,
    CASE
      WHEN (grade_c = 'Freshman'
      AND indicator_low_income_c = 'Yes'
      AND first_generation_fy_20_c = 'Yes') THEN 1
      ELSE 0
    END AS first_gen_and_male,
  FROM
    `data-warehouse-289815.salesforce_clean.contact_template`
  WHERE
    college_track_status_c = '11A'
)
SELECT 
*
FROM gather_data
-- SELECT
--   site_short,
--   SUM(above_325_gpa) AS SD_senior_above_325,
--   SUM(male_student) AS SD_ninth_grade_male,
--   SUM(first_gen_and_male) AS SD_ninth_grade_first_gen_male
-- FROM
--   gather_hs_data
-- GROUP BY
--   site_short