WITH gather_data AS (
  SELECT
    HSS.contact_id,
    CAT.site_short,
    CAT.Most_Recent_GPA_Cumulative_bucket,
    CAT.high_school_graduating_class_c,
    the_most_valuable_part_of_college_track_for_me_is,
    the_main_reason_i_am_excited_to_keep_coming_to_college_track_is,
    a_service_resource_that_college_track_provides_that_i_wish_i_received_more_o,
    i_think_college_track_can_do_a_better_job_at,
    do_you_have_any_recommendations_for_college_track_on_how_to_better_support_s,
    at_this_time_what_are_your_career_aspirations_are_there_any_internships_you_,
    what_is_the_main_reason_you_would_not_recommend_college_track_to_another_st,
    what_is_the_main_reason_you_would_recommend_college_track_to_another_studen,
    what_would_make_you_more_likely_to_recommend_college_track_to_another_stude,
    is_there_anything_youd_like_to_share_with_us_that_wasnt_asked_in_this_surve,
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
),
student_prior_215 AS(
  SELECT
    contact_id
  FROM
    `data-warehouse-289815.salesforce_clean.contact_template`
  WHERE
    College_Track_Status_c IN ('11A', '12A', '18a')
    AND Contact_Id NOT IN (
      SELECT
        Contact_c
      FROM
        `data-warehouse-289815.salesforce.contact_pipeline_history_c`
      WHERE
        created_date >= '2021-02-17T22:00:00.000Z'
        AND Name = 'Started/Restarted CT HS Program'
    )
    )
SELECT
  GD.*,
  CASE WHEN NPS_Score = 'Promoters' THEN 1
  ELSE 0
  END AS promoters,
  CASE WHEN NPS_Score = 'Detractors' THEN 1
  ELSE 0
  END AS detractors,
    CASE WHEN SP.Contact_Id IS NOT NULL THEN "Joined Prior to 2/15 ; All Students"
  ELSE "All Students"
  END AS joined_prior 
FROM
  gather_data GD
  LEFT JOIN student_prior_215 SP ON SP.contact_id = GD.Contact_Id