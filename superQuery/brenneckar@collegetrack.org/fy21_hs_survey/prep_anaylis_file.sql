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
    
    
    
    
    
    `data-studio-260217.surveys.determine_positive_answers`(academic_resources_e_g_textbooks_computers) AS  academic_resources_e_g_textbooks_computers,
    
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