CREATE OR REPLACE TABLE `data-studio-260217.surveys.fy21_ps_survey_wide_prepped`
OPTIONS
    (
    description= "fy21 ps survey wide prepped"
    )
AS

WITH gather_rubric_data AS
(
    SELECT
    contact_id AS rubric_contact_id,
    financial_score_color,
    academic_score_color,
    wellness_score_color,
    career_score_color,
    CASE
        WHEN Campus_Outlook_c = "CO_G" THEN "Generally positive outlook on their college/university"
        WHEN Campus_Outlook_c = "CO_Y" THEN "Neutral outlook"
        WHEN Campus_Outlook_c = "CO_R" THEN "Negative outlook"    
        END AS Campus_Outlook_c,
    CASE
        WHEN Support_Network_c = "SN_G" THEN "2+ people in network to check-in with on wellness concerns"
        WHEN Support_Network_c= "SN_Y" THEN "1+ person in network to check-in with on wellness concerns"
        WHEN Support_Network_c = "SN_R" THEN "No one to check-in on wellness concerns"    
    END AS Support_Network_c,
    CASE
        WHEN Personal_Well_Being_c = "PWB_G" THEN "Taking care of themselves, is stable, and is aware of physical and mental health resources on campus or in the community"
        WHEN Personal_Well_Being_c = "PWB_Y" THEN "Struggling physically or emotionally, but are utilizing on campus/community resources to manage"
        WHEN Personal_Well_Being_c = "PWB_R" THEN "Not doing well physically or emotionally and is not utilizing on campus/community resources to manage"
    END AS Personal_Well_Being_c,
    CASE
        WHEN Social_Stability_c = "SS_G" THEN "In a stable & healthy place with all close friends and family"
        WHEN Social_Stability_c = "SS_Y" THEN "Not in a stable & healthy place with all close friends and family, but is managing it in a healthy manner"
        WHEN Social_Stability_c = "SS_R" THEN "Not in a stable & healthy place with close friends and/or family, and not managing it in a healthy manner"
    END AS Social_Stability_c,
    CASE    
        WHEN Campus_Outlook_c = "CO_G" THEN 3
        WHEN Campus_Outlook_c = "CO_Y" THEN 2
        WHEN Campus_Outlook_c = "CO_R" THEN 1
        WHEN Support_Network_c = "SN_G" THEN 3
        WHEN Support_Network_c= "SN_Y" THEN 2
        WHEN Support_Network_c = "SN_R" THEN 1
        WHEN Personal_Well_Being_c = "PWB_G" THEN 3
        WHEN Personal_Well_Being_c = "PWB_Y" THEN 2
        WHEN Personal_Well_Being_c = "PWB_R" THEN 1
        WHEN Social_Stability_c = "SS_G" THEN 3
        WHEN Social_Stability_c = "SS_Y" THEN 2
        WHEN Social_Stability_c = "SS_R" THEN 1
    ELSE 0
    END AS adv_rubric_sort

    FROM 
    `data-studio-260217.college_rubric.filtered_college_rubric`
    WHERE Current_or_Prev_At = 'Previous AT'
),

clean_add_filters AS
(
    SELECT
    *,
    CASE
        WHEN REGEXP_CONTAINS(which_of_the_factors_are_most_responsible_for_you_not_feelin,"Staff turnover / I don't know the staff anymore") THEN 1
        ELSE 0
    END AS staff_turnover_count,
    CASE
        WHEN REGEXP_CONTAINS(which_of_the_factors_are_most_responsible_for_you_not_feelin,"I'm too busy / too much time required to maintain that connection") THEN 1
        ELSE 0
    END AS too_busy_count,
    CASE
        WHEN REGEXP_CONTAINS(which_of_the_factors_are_most_responsible_for_you_not_feelin, "I rarely see or hear from anyone at College Track besides my CT college advisor") THEN 1
        ELSE 0
    END AS rarely_hear_count,
    CASE
        WHEN REGEXP_CONTAINS(which_of_the_factors_are_most_responsible_for_you_not_feelin, "I'm in other programs / use school resources that also provide support services") THEN 1
        ELSE 0
    END AS other_program_count,
    CASE
        WHEN REGEXP_CONTAINS(which_of_the_factors_are_most_responsible_for_you_not_feelin, "I'm thriving at college / just don't feel I need much support") THEN 1
        ELSE 0
    END AS thriving_count,
    CASE
        WHEN REGEXP_CONTAINS(which_of_the_factors_are_most_responsible_for_you_not_feelin, "Other (please specify in text box below)") THEN 1
        ELSE 0
    END AS other_count,
    CASE
        WHEN REGEXP_CONTAINS(what_types_of_support_resources_information_would_you_be_int,"Career advice & exploration") THEN 1
        ELSE 0
    END AS career_advice_count,
    
    CASE
        WHEN REGEXP_CONTAINS(what_types_of_support_resources_information_would_you_be_int,"Graduate school information") THEN 1
        ELSE 0
    END AS grad_school_info_count,
    CASE
        WHEN REGEXP_CONTAINS(what_types_of_support_resources_information_would_you_be_int,"Handling personal finances") THEN 1
        ELSE 0
    END AS personal_finances_count,
    CASE
        WHEN REGEXP_CONTAINS(what_types_of_support_resources_information_would_you_be_int,"Job, internship, & volunteer opprotunities") THEN 1
        ELSE 0
    END AS career_opps_count,
    CASE
        WHEN REGEXP_CONTAINS(what_types_of_support_resources_information_would_you_be_int,"Networking & building connections") THEN 1
        ELSE 0
    END AS networking_count,
    CASE
        WHEN REGEXP_CONTAINS(what_types_of_support_resources_information_would_you_be_int,"Resume, application, & interview advice") THEN 1
        ELSE 0
    END AS resume_count,
    CASE
        WHEN REGEXP_CONTAINS(what_types_of_support_resources_information_would_you_be_int,"Starting a business") THEN 1
        ELSE 0
    END AS starting_biz_count,
     CASE
        WHEN REGEXP_CONTAINS(what_types_of_support_resources_information_would_you_be_int,"Work life balance") THEN 1
        ELSE 0
    END AS work_life_count,

    FROM `data-studio-260217.surveys.fy21_ps_survey`
    LEFT JOIN `data-studio-260217.surveys.fy21_ps_survey_filters_clean` ON filter_contact_id = contact_id
    WHERE site_short IS NOT NULL
)
    SELECT
    * except (rubric_contact_id, filter_contact_id)
    FROM clean_add_filters
    LEFT JOIN gather_rubric_data ON gather_rubric_data.rubric_contact_id = contact_id




/*WITH bucket_data AS
(

    SELECT
    Contact_Id AS bucket_contact_id,
    CASE    
        WHEN how_often_are_you_in_touch_with_your_college_track_advisor ='I have not had any interaction with my advisor to date /Not sure who my advisor is' THEN 0
        WHEN how_often_are_you_in_touch_with_your_college_track_advisor ='About once a year' THEN 1
        WHEN how_often_are_you_in_touch_with_your_college_track_advisor ='Once every other month' THEN 2
        WHEN how_often_are_you_in_touch_with_your_college_track_advisor ='Once a month' THEN 3
        WHEN how_often_are_you_in_touch_with_your_college_track_advisor ='Twice a month' THEN 4
        WHEN how_often_are_you_in_touch_with_your_college_track_advisor ='Every week' THEN 5
        ELSE NULL
    END AS current_comms_frequency,
    CASE
        WHEN ideally_during_the_next_term_how_often_would_you_find_it_use ='I do not wish to be contacted by an advisor' THEN 0
        WHEN ideally_during_the_next_term_how_often_would_you_find_it_use ='About once a year' THEN 1
        WHEN ideally_during_the_next_term_how_often_would_you_find_it_use ='Once every other month' THEN 2
        WHEN ideally_during_the_next_term_how_often_would_you_find_it_use ='Once a month' THEN 3
        WHEN ideally_during_the_next_term_how_often_would_you_find_it_use ='Twice a month' THEN 4
        WHEN ideally_during_the_next_term_how_often_would_you_find_it_use ='Every week' THEN 5
        ELSE NULL
    END AS future_comms_frequency,
    CASE
        WHEN (how_likely_are_you_to_recommend_college_track_to_a_student_w = '10 - extremely likely'
        OR how_likely_are_you_to_recommend_college_track_to_a_student_w ='9') THEN 3
        WHEN (how_likely_are_you_to_recommend_college_track_to_a_student_w = '8'
        OR how_likely_are_you_to_recommend_college_track_to_a_student_w = '7') THEN 2
        ELSE 1
    END AS NPS_bucket_num,
    CASE
        WHEN what_format_best_describes_your_college_experience_during_th ='In person only - All my classes & college activities have been in person and on my college campus' THEN 3
        WHEN what_format_best_describes_your_college_experience_during_th ='Mixed - For part of this year my college classes & related activities have been in person on my college campus but other times they were remote/online only (ie zoom, online learning, recorded lessons, virtual study groups, etc.)' THEN 2
        ELSE 1
    END AS covid_college_num,
    CASE
        WHEN which_choice_best_represents_your_living_situation_during_th = 'Living in on-campus housing on college campus'THEN 3
        WHEN which_choice_best_represents_your_living_situation_during_th = "Mixed - part of the year living on or near campus AND part of the year remote (at home, parent's house, relatives, etc.)" THEN 2
        ELSE 1
    END AS covid_living_num,
    
    FROM `data-studio-260217.surveys.fy21_ps_survey`
),

bucket_calc AS
(
    SELECT   
    bucket_contact_id,
    CASE
        WHEN current_comms_frequency = future_comms_frequency THEN 'Communication satisfactory'
        WHEN current_comms_frequency > future_comms_frequency THEN 'Less communication desired'
        WHEN current_comms_frequency < future_comms_frequency THEN 'More communication desired'
        ELSE 'Could not predict future communication needs'
    END AS comms_bucket,
    CASE    
        WHEN NPS_bucket_num = 3 THEN 'Promoter'
        WHEN NPS_bucket_num = 2 THEN 'Passive'
        ELSE 'Detractor'
    END AS NPS_bucket,
    CASE    
        WHEN NPS_bucket_num = 3 THEN 1
        ELSE 0
    END AS nps_promoter_count,
    CASE
        WHEN NPS_bucket_num = 1 THEN 1
        ELSE 0
    END AS nps_detractor_count,
    CASE
        WHEN (covid_college_num = 3 AND covid_living_num = 3) THEN 'In person only'
        WHEN (covid_college_num = 1 AND covid_living_num = 1) THEN 'Remote only'
        ELSE "Mix of remote & in-person"
    END AS covid_bucket
    
    FROM bucket_data
),

gather_filter_data AS
(
    SELECT  
    contact_id AS filter_contact_id,
    College_Track_Status_Name,
    region_short,
    site_short,
    high_school_graduating_class_c,
    Ethnic_background_c,
    Gender_c,
    current_cc_advisor_2_c, 
    readiness_composite_off_c,
    `data-warehouse-289815.UDF.determine_buckets` (college_eligibility_gpa_11th_grade,.25,2.5,3.75,"") AS college_elig_gpa_bucket,
    `data-warehouse-289815.UDF.sort_created_buckets`(college_eligibility_gpa_11th_grade,.25,2.5,3.75) AS college_elig_gpa_sort,
    Most_Recent_GPA_Cumulative_bucket,
    school_type,
    Current_Major_c,
    credit_accumulation_pace_c,
    bucket_calc.comms_bucket,
    bucket_calc.nps_bucket,
    CASE    
        WHEN bucket_calc.nps_bucket = 'Promoter' THEN 1
        ELSE 0
    END AS promoters_count,
    CASE    
        WHEN bucket_calc.nps_bucket = 'Detractor' THEN 1
        ELSE 0
    END AS detractors_count,
    bucket_calc.covid_bucket,

    FROM `data-warehouse-289815.salesforce_clean.contact_template`
    LEFT JOIN bucket_calc ON bucket_calc.bucket_contact_id = contact_id
    WHERE college_track_status_c IN ('15A','16A','17A')
    
)
*/

    