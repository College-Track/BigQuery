WITH gather_data AS (
  SELECT
    HSS.contact_id,
    CAT.site_short,
    CAT.Most_Recent_GPA_Cumulative_bucket,
    CAT.high_school_graduating_class_c,
    -- Likert Awners,
     `data-studio-260217.surveys.determine_positive_answers`(ct_provides_a_supportive_learning_environment_for_me) AS ct_provides_a_supportive_learning_environment_for_me,
    `data-studio-260217.surveys.determine_positive_answers`(when_im_at_ct_i_feel_like_i_belong) AS when_im_at_ct_i_feel_like_i_belong,
    `data-studio-260217.surveys.determine_positive_answers`(the_friends_ive_made_at_ct_support_me_in_working_towards_a_college_degree) AS the_friends_ive_made_at_ct_support_me_in_working_towards_a_college_degree,
    `data-studio-260217.surveys.determine_positive_answers`(i_feel_connected_to_at_least_one_ct_staff_member) AS i_feel_connected_to_at_least_one_ct_staff_member,
    `data-studio-260217.surveys.determine_positive_answers`(ct_provides_me_enough_opportunities_to_form_meaningful_relationships_with_staff) AS ct_provides_me_enough_opportunities_to_form_meaningful_relationships_with_staff,
    `data-studio-260217.surveys.determine_positive_answers`(i_make_it_a_priority_to_attend_my_ct_sessions_workshops) AS i_make_it_a_priority_to_attend_my_ct_sessions_workshops,
    `data-studio-260217.surveys.determine_positive_answers`(my_site_is_run_effectively_examples_i_know_how_to_find_zoom_links_i_receive_site) AS my_site_is_run_effectively_examples_i_know_how_to_find_zoom_links_i_receive_site,
    
    `data-studio-260217.surveys.determine_positive_answers`(inside_your_college_track_center) AS inside_your_college_track_center,
    `data-studio-260217.surveys.determine_positive_answers`(in_the_area_outside_your_center) AS in_the_area_outside_your_center,
    `data-studio-260217.surveys.determine_positive_answers`(i_believe_earning_a_college_degree_will_help_me_achieve_my_dreams_and_improv) AS i_believe_earning_a_college_degree_will_help_me_achieve_my_dreams_and_improv,
    `data-studio-260217.surveys.determine_positive_answers`(college_track_keeps_my_parents_informed_about_my_progress_to_college) AS college_track_keeps_my_parents_informed_about_my_progress_to_college,
    `data-studio-260217.surveys.determine_positive_answers`(check_ins_with_ct_staff_academic_coaches_success_coaches_etc) AS check_ins_with_ct_staff_academic_coaches_success_coaches_etc,
    `data-studio-260217.surveys.determine_positive_answers`(credit_recovery_courses_opportunities) AS credit_recovery_courses_opportunities,
    `data-studio-260217.surveys.determine_positive_answers`(academic_resources_e_g_textbooks_computers) AS academic_resources_e_g_textbooks_computers,
    `data-studio-260217.surveys.determine_positive_answers`(academic_advising_e_g_study_habits_learning_about_college_eligible_vs_competitiv) AS academic_advising_e_g_study_habits_learning_about_college_eligible_vs_competitiv,
    `data-studio-260217.surveys.determine_positive_answers`(ct_helps_me_better_understand_what_im_learning_in_my_high_school_classes) AS ct_helps_me_better_understand_what_im_learning_in_my_high_school_classes,
    `data-studio-260217.surveys.determine_positive_answers`(cts_support_has_increased_my_confidence_when_taking_practice_official_college_en) AS cts_support_has_increased_my_confidence_when_taking_practice_official_college_en,
    `data-studio-260217.surveys.determine_positive_answers`(ct_helps_me_better_understand_that_i_am_in_control_of_my_academic_performance) AS ct_helps_me_better_understand_that_i_am_in_control_of_my_academic_performance,
    
    
    

  FROM
    `data-studio-260217.surveys.fy21_hs_survey` HSS
    LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_template` CAT ON CAT.Contact_Id = HSS.contact_id
  WHERE
    HSS.contact_id IS NOT NULL
    AND site_short IS NOT NULL
)

SELECT
  GD.*

FROM
  gather_data GD