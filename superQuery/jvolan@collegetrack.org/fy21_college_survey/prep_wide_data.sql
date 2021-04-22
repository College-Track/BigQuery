CREATE OR REPLACE TABLE `data-studio-260217.surveys.fy21_ps_survey_wide_prepped`
OPTIONS
    (
    description= "fy21 ps survey wide prepped"
    )
AS

WITH bucket_data AS
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

    SELECT
    *,

    FROM `data-studio-260217.surveys.fy21_ps_survey`
    LEFT JOIN gather_filter_data ON gather_filter_data.filter_contact_id = contact_id