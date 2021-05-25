WITH gather_student_data AS(
  SELECT
    site_short,
    high_school_graduating_class_c,
    Most_Recent_GPA_Cumulative_bucket,
    Ethnic_background_c,
    Gender_c,
    full_name_c,
    Contact_Id
  FROM
    `data-warehouse-289815.salesforce_clean.contact_template`
  WHERE
    College_Track_Status_c IN ('11A', '12A', '18a')
),
gather_survey_data AS (
  SELECT
    *
  EXCEPT(
      completion_status,
      completion_time,
      ct_safety_subsection,
      ct_services_subsection,
      aa_ct_experiences_subsection,
      academic_affairs_section,
      academic_support_subsection,
      bank_book_subsection,
      coaching_programming_section,
      college_prep_section,
      college_prep_support_subsection,
      college_track_site,
      confirm_your_high_school_class,
      ct_experience_subsection,
      ct_has_helped_me_improve_my_ability_to_identify_share_things_im_passionate_about,
      ct_site_section,
      earning_degree_value_subsection,
      enter_your_name_if_not_listed_above,
      general_feedback_section,
      i_cant_find_my_name,
      ip_address,
      non_senior_section,
      parents_subsection,
      referrer,
      response_url,
      seniors_ct_support_subsection,
      seniors_section,
      seniors_understanding_subsection,
      spanish_responce,
      student_ct_status,
      student_high_school_class,
      student_info_section,
      student_life_ct_support_subsection,
      student_life_dreams_subsection,
      student_life_section,
      student_name_lookup_begin_typing_to_filter_results,
      submitted_date,
      unprotected_file_list,
      virtual_programming_collaboration_subsection,
      virtual_programming_engagement_excitement_subsection,
      virtual_programming_return_to_ct_subsection,
      virtual_programming_section,
      virtual_programming_self_direction_subsection,
      wellness_programming_section,
      wellness_programming_services_subsection,
      ct_stengths_weakness_section,
      math_programming_subsection
    )
  FROM
    `data-studio-260217.surveys.fy21_hs_survey`
  WHERE
    your_responses_to_this_survey_are_anonymous_we_only_ask_for_your_name_for_determ = 'Yes, I accept to share my survey results with staff at my College Track center.'
)
SELECT
  GCD.site_short,
  GCD.full_name_c,
  GCD.high_school_graduating_class_c,
  GCD.Most_Recent_GPA_Cumulative_bucket,
  GCD.Ethnic_background_c,
  GCD.Gender_c,
  GSD.*,

FROM
  gather_survey_data GSD
  LEFT JOIN gather_student_data GCD ON GCD.Contact_Id = GSD.Contact_Id