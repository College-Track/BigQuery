WITH gather_data AS (
  SELECT
    Contact_Id,
    site_short,
    CASE
      WHEN grade_c = '9th Grade'
      AND (indicator_first_generation_c = true) THEN 1
      ELSE 0
    END AS incoming_cohort_first_gen,
    CASE
      WHEN grade_c = '9th Grade'
      AND (indicator_low_income_c = 'Yes') THEN 1
      ELSE 0
    END AS incoming_cohort_low_income,
  FROM
    `data-warehouse-289815.salesforce_clean.contact_template`
  WHERE
    college_track_status_c = '11A'
),
gather_survey_data AS (
  SELECT
    CT.site_short,
    S.contact_id,
    CASE
      WHEN (
        how_likely_are_you_to_recommend_college_track_to_a_student_who_wants_to_get = '10 - extremely likely'
        OR how_likely_are_you_to_recommend_college_track_to_a_student_who_wants_to_get = '9'
      ) THEN 1
      ELSE 0
    END AS nps_promoter,
    CASE
      WHEN (
        how_likely_are_you_to_recommend_college_track_to_a_student_who_wants_to_get != '10 - extremely likely'
        AND how_likely_are_you_to_recommend_college_track_to_a_student_who_wants_to_get != '9'
        AND how_likely_are_you_to_recommend_college_track_to_a_student_who_wants_to_get != '8'
        AND how_likely_are_you_to_recommend_college_track_to_a_student_who_wants_to_get != '7'
      ) THEN 1
      ELSE 0
    END AS nps_detractor
  FROM
    `data-studio-260217.surveys.fy21_hs_survey` S
    LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_template` CT ON CT.Contact_Id = S.contact_id
)

SELECT
  gather_data.site_short,
  SUM(incoming_cohort_first_gen) AS pro_ops_incoming_cohort_first_gen,
  SUM(incoming_cohort_low_income) AS pro_ops_incoming_cohort_low_income,
  SUM(nps_promoter) AS nps_promoter,
  SUM(nps_detractor)AS nps_detractor
 
  
FROM
  gather_data
  LEFT JOIN gather_survey_data GSD ON GSD.site_short = gather_data.site_short
GROUP BY
  gather_data.site_short