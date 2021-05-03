
    SELECT
    
        Contact_Id,
    
        --filters
        `data-studio-260217.surveys.fy21_ps_survey_filters_clean`.* except(filter_contact_id),

        --survey Qs of interest
        `data-studio-260217.surveys.determine_positive_answers` (i_understood_what_academic_supports_would_be_available_to_me) AS i_understood_what_academic_supports_would_be_available_to_me,
        `data-studio-260217.surveys.determine_positive_answers` (i_located_these_support_services_once_i_arrived_on_campus_or) AS i_located_these_support_services_once_i_arrived_on_campus_or,
        `data-studio-260217.surveys.determine_positive_answers` (i_felt_confident_in_my_ability_to_seek_out_and_use_these_sup) AS i_felt_confident_in_my_ability_to_seek_out_and_use_these_sup,
        `data-studio-260217.surveys.determine_positive_answers` (i_could_pay_for_tuition_and_living_expenses) AS i_could_pay_for_tuition_and_living_expenses,
        `data-studio-260217.surveys.determine_positive_answers` (i_knew_there_were_going_to_be_some_obstacles_in_completing_m) AS i_knew_there_were_going_to_be_some_obstacles_in_completing_m,
        `data-studio-260217.surveys.determine_positive_answers` (i_understood_how_getting_a_college_degree_fit_with_my_larger) AS i_understood_how_getting_a_college_degree_fit_with_my_larger,
        `data-studio-260217.surveys.determine_positive_answers` (most_students_i_met_were_focused_on_getting_a_bachelors_degr) AS most_students_i_met_were_focused_on_getting_a_bachelors_degr,
        `data-studio-260217.surveys.determine_positive_answers` (i_felt_i_belonged_on_my_college_campushelp_note_if_remote_th) AS i_felt_i_belonged_on_my_college_campushelp_note_if_remote_th,
        `data-studio-260217.surveys.determine_positive_answers` (my_college_is_culturally_competenthelp_note_i_felt_that_the_) AS my_college_is_culturally_competenthelp_note_i_felt_that_the_,
        `data-studio-260217.surveys.determine_positive_answers` (my_parent_s_were_involved_and_supportive_during_my_transitio) AS my_parent_s_were_involved_and_supportive_during_my_transitio,
        `data-studio-260217.surveys.determine_positive_answers` (i_knew_who_to_contact_at_college_track_to_get_advice_or_help) AS i_knew_who_to_contact_at_college_track_to_get_advice_or_help,
        `data-studio-260217.surveys.determine_positive_answers` (in_the_past_12th_months_were_you_involved_in_a_club_organiza) AS in_the_past_12th_months_were_you_involved_in_a_club_organiza,
        `data-studio-260217.surveys.determine_positive_answers` (did_you_have_a_leadership_role_with_that_club_organization) AS did_you_have_a_leadership_role_with_that_club_organization,
        `data-studio-260217.surveys.determine_positive_answers` (i_know_where_the_mental_health_center_services_are_on_my_col) AS i_know_where_the_mental_health_center_services_are_on_my_col,
        `data-studio-260217.surveys.determine_positive_answers` (i_intend_to_use_these_services_if_ever_i_should_need_them) AS i_intend_to_use_these_services_if_ever_i_should_need_them,
        `data-studio-260217.surveys.determine_positive_answers` (i_have_a_good_sense_of_what_makes_my_life_meaningful) AS i_have_a_good_sense_of_what_makes_my_life_meaningful,
        `data-studio-260217.surveys.determine_positive_answers` (my_life_has_a_clear_sense_of_purpose) AS my_life_has_a_clear_sense_of_purpose,
        `data-studio-260217.surveys.determine_positive_answers` (i_have_discovered_a_satisfying_life_purpose) AS i_have_discovered_a_satisfying_life_purpose,
        `data-studio-260217.surveys.determine_positive_answers` (i_know_what_steps_i_will_take_next_to_pursue_my_purpose_in_l) AS i_know_what_steps_i_will_take_next_to_pursue_my_purpose_in_l,
        `data-studio-260217.surveys.determine_positive_answers` (how_often_do_you_use_goal_setting_to_ensure_you_stay_on_trac) AS how_often_do_you_use_goal_setting_to_ensure_you_stay_on_trac,
        `data-studio-260217.surveys.determine_positive_answers` (how_often_do_you_stay_focused_on_the_same_goal_for_several_m) AS how_often_do_you_stay_focused_on_the_same_goal_for_several_m,
        `data-studio-260217.surveys.determine_positive_answers` (how_confident_are_you_that_you_can_complete_all_the_work_tha) AS how_confident_are_you_that_you_can_complete_all_the_work_tha,
        `data-studio-260217.surveys.determine_positive_answers` (how_confident_are_you_that_you_can_learn_all_the_material_pr) AS how_confident_are_you_that_you_can_learn_all_the_material_pr,
        `data-studio-260217.surveys.determine_positive_answers` (in_the_past_12_months_did_you_have_a_job_to_help_you_pay_the) AS in_the_past_12_months_did_you_have_a_job_to_help_you_pay_the,
        `data-studio-260217.surveys.determine_positive_answers` (since_the_beginning_of_college_how_many_total_internships_or) AS since_the_beginning_of_college_how_many_total_internships_or,
        `data-studio-260217.surveys.determine_positive_answers` (are_you_planning_on_doing_an_internship_prior_to_obtaining_y) AS are_you_planning_on_doing_an_internship_prior_to_obtaining_y,
        `data-studio-260217.surveys.determine_positive_answers` (choosing_your_major_or_minor_field_of_study) AS choosing_your_major_or_minor_field_of_study,
        `data-studio-260217.surveys.determine_positive_answers` (providing_advice_or_resources_to_help_manage_your_course_loa) AS providing_advice_or_resources_to_help_manage_your_course_loa,
        `data-studio-260217.surveys.determine_positive_answers` (directing_you_to_resources_to_help_you_be_academically_succe) AS directing_you_to_resources_to_help_you_be_academically_succe,
        `data-studio-260217.surveys.determine_positive_answers` (supporting_your_financial_aid_needs_filling_out_fafsa_financ) AS supporting_your_financial_aid_needs_filling_out_fafsa_financ,
        `data-studio-260217.surveys.determine_positive_answers` (providing_advice_or_resources_to_help_you_manage_your_financ) AS providing_advice_or_resources_to_help_you_manage_your_financ,
        `data-studio-260217.surveys.determine_positive_answers` (providing_advice_or_resources_to_help_you_be_career_ready_re) AS providing_advice_or_resources_to_help_you_be_career_ready_re,
        `data-studio-260217.surveys.determine_positive_answers` (identifying_or_evaluating_potential_career_options) AS identifying_or_evaluating_potential_career_options,
        `data-studio-260217.surveys.determine_positive_answers` (my_ct_advisor_provides_info_or_connects_me_to_additional_res) AS my_ct_advisor_provides_info_or_connects_me_to_additional_res,
        `data-studio-260217.surveys.determine_positive_answers` (my_ct_advisor_pushes_me_to_find_my_own_answers_to_my_questio) AS my_ct_advisor_pushes_me_to_find_my_own_answers_to_my_questio,
        `data-studio-260217.surveys.determine_positive_answers` (my_ct_advisor_and_i_discuss_and_work_through_problems_obstac) AS my_ct_advisor_and_i_discuss_and_work_through_problems_obstac,
        `data-studio-260217.surveys.determine_positive_answers` (i_feel_like_my_ct_advisor_cares_about_me_as_a_person) AS i_feel_like_my_ct_advisor_cares_about_me_as_a_person,
        `data-studio-260217.surveys.determine_positive_answers` (when_i_talk_to_my_ct_advisor_i_leave_feeling_heard_and_suppo) AS when_i_talk_to_my_ct_advisor_i_leave_feeling_heard_and_suppo,
        `data-studio-260217.surveys.determine_positive_answers` (how_likely_are_you_to_recommend_college_track_to_a_student_w) AS how_likely_are_you_to_recommend_college_track_to_a_student_w,
        `data-studio-260217.surveys.determine_positive_answers` (i_still_feel_strongly_connected_to_college_track) AS i_still_feel_strongly_connected_to_college_track,
        `data-studio-260217.surveys.determine_positive_answers` (i_have_been_provided_enough_opportunities_to_stay_connected_) AS i_have_been_provided_enough_opportunities_to_stay_connected_,
        `data-studio-260217.surveys.determine_positive_answers` (i_always_know_who_my_ct_college_advisor_is_and_never_have_is) AS i_always_know_who_my_ct_college_advisor_is_and_never_have_is,
        `data-studio-260217.surveys.determine_positive_answers` (besides_my_ct_college_advisor_i_have_at_least_one_ct_staff_m) AS besides_my_ct_college_advisor_i_have_at_least_one_ct_staff_m,
        `data-studio-260217.surveys.determine_positive_answers` (i_am_able_to_receive_my_scholarship_funds_from_college_track) AS i_am_able_to_receive_my_scholarship_funds_from_college_track,
        `data-studio-260217.surveys.determine_positive_answers` (which_of_the_factors_are_most_responsible_for_you_not_feelin) AS which_of_the_factors_are_most_responsible_for_you_not_feelin,
        
        FROM `data-studio-260217.surveys.fy21_ps_survey`
        LEFT JOIN `data-studio-260217.surveys.fy21_ps_survey_filters_clean` ON `data-studio-260217.surveys.fy21_ps_survey_filters_clean`.filter_contact_id = Contact_Id
        