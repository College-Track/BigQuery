WITH gather_data AS (
  SELECT
    HSS.contact_id,
    CAT.site_short,
    CAT.Most_Recent_GPA_Cumulative_bucket,
    CAT.high_school_graduating_class_c,
    academic_resources_e_g_textbooks_computers,
    `data-studio-260217.surveys.determine_positive_answers`(academic_resources_e_g_textbooks_computers) AS  academic_resources_e_g_textbooks_computers_positive,
    CASE
      WHEN (
        how_likely_are_you_to_recommend_college_track_to_a_student_who_wants_to_get = '10 - extremely likely'
        OR how_likely_are_you_to_recommend_college_track_to_a_student_who_wants_to_get = '9'
      ) THEN "Promoters"
      WHEN (
        how_likely_are_you_to_recommend_college_track_to_a_student_who_wants_to_get = '8'
        OR how_likely_are_you_to_recommend_college_track_to_a_student_who_wants_to_get = '7'
      ) THEN "Passives"
      ELSE "Detractors"
    END AS NPS_Score
  FROM
    `data-studio-260217.surveys.fy21_hs_survey` HSS
    LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_template` CAT ON CAT.Contact_Id = HSS.contact_id
  WHERE
    HSS.contact_id IS NOT NULL
    AND site_short IS NOT NULL
)

SELECT
  GD.*,
  CASE WHEN NPS_Score = 'Promoters' THEN 1
  ELSE 0
  END AS promoters,
  CASE WHEN NPS_Score = 'Detractors' THEN 1
  ELSE 0
  END AS detractors,

FROM
  gather_data GD
