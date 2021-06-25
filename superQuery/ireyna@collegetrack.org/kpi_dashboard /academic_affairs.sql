 SELECT
    Contact_Id,
    site_short,
      Ethnic_background_c,
      Gender_c,
    -- % of students with a 3.25 GPA
    -- Will need to make this more dynamic to account for GPA lag
    CASE
      WHEN Prev_AT_Cum_GPA >= 3.25 THEN 1
      ELSE 0
    END AS above_325_gpa,
    -- % of seniors who are composite ready
    -- Will need to add in the opt-out indicator once it is made.
    CASE
      WHEN Readiness_Composite_Off_c = '1. Ready'
      AND (
        grade_c = '12th Grade'
        OR (
          grade_c = 'Year 1'
          AND indicator_years_since_hs_graduation_c = 0
        )
      )
      AND contact_official_test_prep_withdrawal IS NULL THEN 1
      ELSE 0
    END AS composite_ready,
    -- % of seniors who are composite ready (11th grade proxy)
    CASE
      WHEN Readiness_Composite_Off_c = '1. Ready'
      AND contact_official_test_prep_withdrawal IS NULL
      AND (grade_c = '11th Grade') THEN 1
      ELSE 0
    END AS composite_ready_eleventh_grade,
    -- % of not ready and near ready students who become composite ready by the highest official exam score
    CASE
      WHEN Readiness_10_th_Composite_c IN('2. Near Ready', '3. Not Ready')
      AND contact_official_test_prep_withdrawal IS NULL
      AND grade_c NOT IN ('9th Grade', '10th Grade', '11th Grade') THEN 1
      ELSE 0
    END AS tenth_grade_test_not_ready,
    CASE
      WHEN (Readiness_Composite_Off_c = '1. Ready')
      AND contact_official_test_prep_withdrawal IS NULL
      AND (
        Readiness_10_th_Composite_c IN('2. Near Ready', '3. Not Ready')
      ) THEN 1
      ELSE 0
    END AS offical_test_ready
  FROM
    `data-warehouse-289815.salesforce_clean.contact_at_template`
  WHERE
    current_as_c = true
    AND college_track_status_c IN ('11A')