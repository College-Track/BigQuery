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
  FROM
    `data-studio-260217.surveys.fy21_hs_survey_long` HSSL
    LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_template` C ON C.Contact_Id = HSSL.contact_id
  WHERE
    HSSL.Contact_Id IS NOT NULL
    AND site_short IS NOT NULL
)
SELECT
  *
FROM
  gather_data
