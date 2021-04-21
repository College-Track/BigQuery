WITH gather_filter_data AS
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
    college_eligibility_gpa_11th_grade,
    school_type,
    Current_Major_c,
    credit_accumulation_pace_c,
    Most_Recent_GPA_Cumulative_bucket,
    
    FROM `data-warehouse-289815.salesforce_clean.contact_template`
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
        WHEN
        (question = 'How likely are you to recommend College Track to a student who wants to graduate college?'
        AND answer = '10 - extremely likely') THEN '10'
        Else answer
    END AS answer_clean,
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