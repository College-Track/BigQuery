WITH gather_data AS (
  SELECT
    HSS.contact_id,
    CAT.site_short,
    CAT.Most_Recent_GPA_Cumulative_bucket,
    CAT.high_school_graduating_class_c the_most_valuable_part_of_college_track_for_me_is,
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
      WHEN how_likely_are_you_to_recommend_college_track_to_a_student_who_wants_to_get = '10 - extremely likely'
      OR how_likely_are_you_to_recommend_college_track_to_a_student_who_wants_to_get = '9' THEN "Promoter"
      ELSE "Detractor"
    END AS NPS_Score
  FROM
    `data-studio-260217.surveys.fy21_hs_survey` HSS
    LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_template` CAT ON CAT.Contact_Id = HSS.contact_id
  WHERE
    HSS.contact_id IS NOT NULL
    AND site_short IS NOT NULL
)
SELECT
  *
FROM
  gather_data