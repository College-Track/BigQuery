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
        AND HSSL.answer = '$1,600'
      ) THEN "Correct"
      WHEN (
        HSSL.question = '5.3 If you complete 100 total community service hours during High School, how much Bank Book money will you get?'
        AND HSSL.answer != '$1,600'
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
    0 as sort_column
  FROM
    `data-studio-260217.surveys.fy21_hs_survey_long` HSSL
    LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_template` C ON C.Contact_Id = HSSL.contact_id
  WHERE
    HSSL.Contact_Id IS NOT NULL
    AND site_short IS NOT NULL
)
SELECT
  *,
  CASE
    WHEN answer = "Strongly Agree" THEN 0
    WHEN answer = 'Agree' THEN 1
    WHEN answer = 'Neutral' THEN 2
    WHEN answer = 'Disagree' THEN 3
    WHEN answer = 'Strongly Disagree' THEN 4
    ELSE sort_column
  END AS sort_column,
  CASE
    WHEN answer = "Very Safe" THEN 0
    WHEN answer = 'Somewhat Safe' THEN 1
    WHEN answer = 'Somewhat Unsafe' THEN 2
    WHEN answer = 'Very Unsafe' THEN 3
    WHEN answer = 'Prefer not to answer' THEN 4
    ELSE sort_column
  END AS sort_column,
  CASE
    WHEN answer = "Extremely helpful" THEN 0
    WHEN answer = 'Very helpful' THEN 1
    WHEN answer = 'Somewhat helpful' THEN 2
    WHEN answer = 'A little helpful' THEN 3
    WHEN answer = 'Not at all helpful' THEN 4
    WHEN answer = "I haven't used this resource at CT" THEN 5
    ELSE sort_column
  END AS sort_column,  
  CASE
    WHEN answer = "Extremely Excited" THEN 0
    WHEN answer = 'Quite Excited' THEN 1
    WHEN answer = 'Somewhat Excited' THEN 2
    WHEN answer = 'Slightly Excited' THEN 3
    WHEN answer = 'Not at all Excited' THEN 4
    ELSE sort_column
  END AS sort_column,    
  CASE
    WHEN answer = "Almost Always" THEN 0
    WHEN answer = 'Often' THEN 1
    WHEN answer = 'Sometimes' THEN 2
    WHEN answer = 'Not very often' THEN 3
    ELSE sort_column
  END AS sort_column,   
FROM
  gather_data