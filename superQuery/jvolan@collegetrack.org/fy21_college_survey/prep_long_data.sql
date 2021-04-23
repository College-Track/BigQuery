
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
        WHEN question = 'College Completion Programming during High School(Support with college applications, college exposure events, college essays, etc.)' THEN 'College Completion Programming during HS'
        WHEN question = 'Academic Programming during High School(Tutoring, ACT/SAT prep, math support, academic coaches, etc.)' THEN 'Academic Programming during HS'
        WHEN question = 'Student Life Programming(Meaningful summer experiences, community service, student dreams, passion projects, student life workshops, etc.)' THEN 'Student Life Programming'
        WHEN question = "Most students I met were focused on getting a bachelor's degreeHelp note: if remote, think of the students you've met virtually via zoom, online class, study groups, office hours, etc." THEN "Most students I met were focused on getting a bachelor's degree"
        WHEN question = "I felt I belonged on my college campusHelp note: if remote, think of your virtual activities & opportunities to engage with students, professors, and other campus staff" THEN "I felt I belonged on my college campus"
        WHEN question = "My college is culturally competentHelp Note: I felt that the adults on campus helping me with academics, financial, and career counseling understood my values." THEN "My college is culturally competent"
        WHEN question = "My parent(s) were involved and supportive during my transition to collegeHelp Note: If your main caregiver/guardian(s) was another adult (Grandparent(s), Aunt/Uncle, Legal Guardian, etc.), please answer this question with them in mind." THEN "My parent(s) were involved and supportive during my transition to college"
        WHEN question = "I knew who to contact at College Track to get advice or helpHelp Note: For example help accessing your bank book money or talking about your experiences as a new college student." THEN "I knew who to contact at College Track to get advice or help"
        WHEN question = "I understood what academic supports would be available to me on campus (or online on college website if remote) Help note: tutoring, writing center, math help, study groups, office hours, etc." THEN "I understood what academic supports would be available to me on campus (or online on college website if remote)"
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
    -- likert sort
    CASE
    WHEN answer = "Strongly Agree" THEN 1
    WHEN answer = 'Agree' THEN 2
    WHEN answer = 'Neutral' THEN 3
    WHEN answer = 'Disagree' THEN 4
    WHEN answer = 'Strongly Disagree' THEN 5
    
    WHEN answer = "Extremely Helpful" THEN 1
    WHEN answer = 'Very Helpful' THEN 2
    WHEN answer = 'Moderately Helpful' THEN 3
    WHEN answer = 'Slightly Helpful' THEN 4
    WHEN answer = 'Not Helpful' THEN 5
    WHEN answer = "Don't discuss with CT advisor" THEN 6
    
    WHEN answer = "Extremely likely" THEN 1
    WHEN answer = 'Likely' THEN 2
    WHEN answer = 'Neutral' THEN 3
    WHEN answer = 'Not likely' THEN 4
    WHEN answer = 'Not at all likely' THEN 5
    WHEN answer = 'N/A' THEN 6

    
    WHEN answer = "Almost always" THEN 1
    WHEN answer = 'Frequently' THEN 2
    WHEN answer = 'Sometimes' THEN 3
    WHEN answer = 'Once in a while' THEN 4
    WHEN answer = 'Almost never' THEN 5

    WHEN answer = 'Extremely confident' THEN 1
    WHEN answer = 'Quiet confident' THEN 2
    WHEN answer = 'Somewhat confident' THEN 3
    WHEN answer = 'Slightly confident' THEN 4
    WHEN answer = 'Not at all confident' THEN 5
    
    WHEN answer = 'Every week' THEN 1
    WHEN answer = 'Twice a month' THEN 2
    WHEN answer = 'Once a month' THEN 3
    WHEN answer = "Once every other month" THEN 4
    WHEN answer = 'About once a year' THEN 5
    WHEN answer = "I have not had any interaction with my advisor to date / Not sure who my advisor is" THEN 6
    WHEN answer = 'I cannot predict at this point' THEN 7
    WHEN answer = 'I do not wish to be contacted by an advisor' THEN 8
    
     WHEN answer = "Extremely Interested" THEN 1
    WHEN answer = 'Very Interested' THEN 2
    WHEN answer = 'Moderately Interested' THEN 3
    WHEN answer = 'Slightly Interested' THEN 4
    WHEN answer = 'Not Interested' THEN 5
    
    ELSE NULL
  END AS sort_column
    

    FROM `data-studio-260217.surveys.fy21_ps_survey_long`
    LEFT JOIN `data-studio-260217.surveys.fy21_ps_survey_filters_clean` ON `data-studio-260217.surveys.fy21_ps_survey_filters_clean`.filter_contact_id = contact_id
)

    SELECT
    *,
    `data-studio-260217.surveys.determine_positive_answers` (answer) AS positive_answer

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
    
