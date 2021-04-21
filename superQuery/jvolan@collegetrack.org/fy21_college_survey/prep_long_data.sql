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
        WHEN (covid_college_num = 3 AND covid_living_num = 3) THEN 'In-Person'
        WHEN (covid_college_num = 1 AND covid_living_num = 1) THEN 'Remote Only'
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

    
pssl_with_filter_data AS
(
    SELECT
    Contact_Id,
    section,
    sub_section,
    question,
    CASE
    -- clean NPS
    WHEN
        (question = 'How likely are you to recommend College Track to a student who wants to graduate college?'
        AND answer = '10 - extremely likely') THEN '10'
    --clean export typos
    WHEN answer = 'ExtremelyInterested' THEN 'Extremely Interested'
    WHEN answer = 'VeryInterested' THEN 'Very Interested'
    WHEN answer = 'ModeratelyInterested' THEN 'Moderately Interested'
    WHEN answer = 'SlightlyInterested' THEN 'Slightly Interested'
    WHEN answer = 'NotInterested' THEN 'Not Interested'
    Else answer
    END AS answer,
    gather_filter_data.* except(filter_contact_id),

    FROM `data-studio-260217.surveys.fy21_ps_survey_long`
    LEFT JOIN gather_filter_data ON gather_filter_data.filter_contact_id = Contact_Id
)

    SELECT
    *
    FROM pssl_with_filter_data
    


/*
WITH gather_data AS (
  SELECT
    HSSL.contact_Id,
    HSSL.question,
    CASE
      WHEN (
        HSSL.question = '5.2 At the end of the semester, what attendance % do you need in order to get $100 for Bank Book?'
        AND HSSL.answer = '90%'
      ) THEN "Correct"
      WHEN (
        HSSL.question = '5.2 At the end of the semester, what attendance % do you need in order to get $100 for Bank Book?'
        AND HSSL.answer != '90%'
      ) THEN "Incorrect"
      WHEN (
        HSSL.question = '5.3 If you complete 100 total community service hours during High School, how much Bank Book money will you get?'
        AND HSSL.answer LIKE '%$1,600%'
      ) THEN "Correct"
      WHEN (
        HSSL.question = '5.3 If you complete 100 total community service hours during High School, how much Bank Book money will you get?'
        AND HSSL.answer NOT LIKE  '%$1,600%'
      ) THEN "Incorrect"
      WHEN (
        HSSL.question = '5.4 At the end of the semester, what GPA level do you need in order to get $400 for Bank Book?'
        AND HSSL.answer = '3.0'
      ) THEN "Correct"
      WHEN (
        HSSL.question = '5.4 At the end of the semester, what GPA level do you need in order to get $400 for Bank Book?'
        AND HSSL.answer != '3.0'
      ) THEN "Incorrect"
      WHEN (
        HSSL.question = '5.5 If your GPA is below 3.0, how much do you have to raise your GPA in order to get $200 for Bank Book?'
        AND HSSL.answer = 'Raise GPA by .5 points'
      ) THEN "Correct"
      WHEN (
        HSSL.question = '5.5 If your GPA is below 3.0, how much do you have to raise your GPA in order to get $200 for Bank Book?'
        AND HSSL.answer != 'Raise GPA by .5 points'
      ) THEN "Incorrect"
      ELSE HSSL.answer
    END AS answer,
    HSSL.section,
    HSSL.sub_section,
    C.site_short,
    C.Most_Recent_GPA_Cumulative_bucket,
    C.high_school_graduating_class_c
  FROM
    `data-studio-260217.surveys.fy21_hs_survey_long` HSSL
    LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_template` C ON C.Contact_Id = HSSL.contact_id
  WHERE
    HSSL.Contact_Id IS NOT NULL
    AND site_short IS NOT NULL
)
SELECT
  *
EXCEPT
  (answer),
  CASE
    WHEN answer = "Strongly Agree" THEN 1
    WHEN answer = 'Agree' THEN 2
    WHEN answer = 'Neutral' THEN 3
    WHEN answer = 'Disagree' THEN 4
    WHEN answer = 'Strongly Disagree' THEN 5
    WHEN answer = "Very Safe" THEN 6
    WHEN answer = 'Somewhat Safe' THEN 7
    WHEN answer = 'Somewhat Unsafe' THEN 8
    WHEN answer = 'Very Unsafe' THEN 9
    WHEN answer = 'Prefer not to answer' THEN 10
    WHEN answer = "Extremely helpful" THEN 11
    WHEN answer = 'Very helpful' THEN 12
    WHEN answer = 'Somewhat helpful' THEN 13
    WHEN answer = 'A little helpful' THEN 14
    WHEN answer = 'Not at all helpful' THEN 15
    WHEN answer = "I haven't used this resource at CT" THEN 16
    WHEN answer = "Extremely Excited" THEN 17
    WHEN answer = 'Quite Excited' THEN 18
    WHEN answer = 'Somewhat Excited' THEN 19
    WHEN answer = 'Slightly Excited' THEN 20
    WHEN answer = 'Not at all Excited' THEN 21
    WHEN answer = "Almost Always" THEN 22
    WHEN answer = 'Often' THEN 23
    WHEN answer = 'Sometimes' THEN 24
    WHEN answer = 'Not very often' THEN 25
    ELSE NULL
  END AS sort_column,
  CASE
    WHEN answer = 'Extremely Helpful' THEN 'Extremely helpful'
    WHEN answer = 'Very Helpful' THEN 'Very helpful'
    WHEN answer = 'Somewhat Helpful' THEN 'Somewhat helpful'
    WHEN answer = 'Yes, I have taken part in Math Blast or summer math specific programming at CT' THEN 'Yes, I have taken part in math specific programming or workshops at CT'
    ELSE answer
  END AS answer
FROM
  
  
 */