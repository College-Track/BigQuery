WITH gather_hs_data AS (
  SELECT
    Contact_Id,
    site_short,
    CASE
      WHEN Prev_AT_Cum_GPA >= 3.25 THEN 1
      ELSE 0
    END AS above_325_gpa,
    CASE WHEN Gender_c = 'Male' THEN 1
    ELSE 0
    END as male_student,
    indicator_low_income_c,
    first_generation_fy_20_c
    -- CASE WHEN (indicator_low_income_c = true) AND (first_generation_fy_20_c = 'yes') THEN 1
    -- ELSE 0
    -- END AS first_gen_and_male 
    FROM `data-warehouse-289815.salesforce_clean.contact_template`
    WHERE college_track_status_c = '11A'
    )
    
SELECT *
FROM gather_hs_data