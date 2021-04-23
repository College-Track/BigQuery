
CREATE OR REPLACE TABLE `data-studio-260217.surveys.fy21_ps_survey_long_prepped`
OPTIONS
    (
    description= "fy21 ps survey long prepped"
    )
AS

WITH pssl_with_filter_data AS
(
    SELECT
    Contact_Id,
    section,
    sub_section,
    CASE
    --shorten Q labels
        WHEN question = 'college_completion_programming_during_high_school_support_wi' THEN 'College Completion Programming During HS'
        WHEN question = 'academic_programming_during_high_school_tutoring_act_sat_pre' THEN 'Academic Programming During HS'
        WHEN question = 'student_life_programming_meaningful_summer_experiences_commu' THEN 'Student Life Programming'
        ELSE question
    END AS question,
    CASE
    -- clean NPS
        WHEN
        (question = 'How likely are you to recommend College Track to a student who wants to graduate college?'
        AND answer = '10 - extremely likely') THEN '10'
    --clean typos
        WHEN answer = 'ExtremelyInterested' THEN 'Extremely Interested'
        WHEN answer = 'VeryInterested' THEN 'Very Interested'
        WHEN answer = 'ModeratelyInterested' THEN 'Moderately Interested'
        WHEN answer = 'SlightlyInterested' THEN 'Slightly Interested'
        WHEN answer = 'NotInterested' THEN 'Not Interested'
        WHEN answer = 'StronglyDisagree' THEN 'Strongly Disagree'
        WHEN answer = 'StronglyAgree' THEN 'Strongly Agree'
        Else answer
    END AS answer,
    
    `data-studio-260217.surveys.fy21_ps_survey_filters_clean`.* except(filter_contact_id),

    FROM `data-studio-260217.surveys.fy21_ps_survey_long`
    LEFT JOIN `data-studio-260217.surveys.fy21_ps_survey_filters_clean` ON `data-studio-260217.surveys.fy21_ps_survey_filters_clean`.filter_contact_id = contact_id
)

    SELECT
    *
    FROM pssl_with_filter_data

/*
WITH bucket_data AS
(

    SELECT
    Contact_Id AS bucket_contact_id,
    max(CASE    
        WHEN (question = 'How often are you in touch with your College Track advisor?' AND answer = 'I have not had any interaction with my advisor to date /Not sure who my advisor is') THEN 0
        WHEN (question = 'How often are you in touch with your College Track advisor?' AND answer = 'About once a year') THEN 1
        WHEN (question = 'How often are you in touch with your College Track advisor?' AND answer = 'Once every other month') THEN 2
        WHEN (question = 'How often are you in touch with your College Track advisor?' AND answer = 'Once a month') THEN 3
        WHEN (question = 'How often are you in touch with your College Track advisor?' AND answer = 'Twice a month') THEN 4
        WHEN (question = 'How often are you in touch with your College Track advisor?' AND answer = 'Every week') THEN 5
        ELSE NULL
    END) AS current_comms_frequency,
    max(CASE
        WHEN (question = 'Ideally, during the next term, how often would you find it useful to be in touch with your College Track advisor?' AND answer = 'I do not wish to be contacted by an advisor') THEN 0
        WHEN (question = 'Ideally, during the next term, how often would you find it useful to be in touch with your College Track advisor?' AND answer = 'About once a year') THEN 1
        WHEN (question = 'Ideally, during the next term, how often would you find it useful to be in touch with your College Track advisor?' AND answer = 'Once every other month') THEN 2
        WHEN (question = 'Ideally, during the next term, how often would you find it useful to be in touch with your College Track advisor?' AND answer = 'Once a month') THEN 3
        WHEN (question = 'Ideally, during the next term, how often would you find it useful to be in touch with your College Track advisor?' AND answer = 'Twice a month') THEN 4
        WHEN (question = 'Ideally, during the next term, how often would you find it useful to be in touch with your College Track advisor?' AND answer = 'Every week') THEN 5
        ELSE NULL
    END) AS future_comms_frequency,
    max(CASE
        WHEN (question = 'How likely are you to recommend College Track to a student who wants to graduate college?'
        AND(answer = '10 - extremely likely'
        OR answer = '9')) THEN 3
        WHEN (question = 'How likely are you to recommend College Track to a student who wants to graduate college?'
        AND(answer = '8'
        OR answer = '7')) THEN 2
        ELSE 1
    END) AS NPS_bucket_num,
    max(CASE
        WHEN (question = 'What format best describes your college experience during this current school year?Help note: classes, office hours, study groups, tutoring, participation in clubs or campus groups, etc.' AND answer = 'In person only - All my classes & college activities have been in person and on my college campus') THEN 3
        WHEN (question = 'What format best describes your college experience during this current school year?Help note: classes, office hours, study groups, tutoring, participation in clubs or campus groups, etc.' AND answer = 'Mixed - For part of this year my college classes & related activities have been in person on my college campus but other times they were remote/online only (ie zoom, online learning, recorded lessons, virtual study groups, etc.)') THEN 2
        ELSE 1
    END) AS covid_college_num,
    max(CASE
        WHEN (question = 'Which choice best represents your living situation during this current school year?' AND (answer = 'Living in on-campus housing on college campus'OR answer = 'Living off-campus housing next to or near college campus')) THEN 3
        WHEN (question = 'Which choice best represents your living situation during this current school year?' AND (answer = "Mixed - part of the year living on or near campus AND part of the year remote (at home, parent's house, relatives, etc.)" OR answer = 'Other')) THEN 2
        ELSE 1
    END) AS covid_living_num,
    
    FROM `data-studio-260217.surveys.fy21_ps_survey_long`
    GROUP BY Contact_Id
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
    bucket_calc.covid_bucket,


    
    FROM `data-warehouse-289815.salesforce_clean.contact_template`
    LEFT JOIN bucket_calc ON bucket_calc.bucket_contact_id = contact_id
    WHERE college_track_status_c IN ('15A','16A','17A')
),
*/
    
