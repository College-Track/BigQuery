WITH gahter_ethnicity_data AS (
  SELECT
    S.contact_id,
    what_race_ethnicity_best_describes_you_for_a_more_detailed_description_of_asian_,
    C.Ethnic_background_c
  FROM
    `data-studio-260217.surveys.fy21_hs_survey` S
    LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_template` C ON C.Contact_Id = S.Contact_id
  WHERE
    S.Contact_Id IS NOT NULL
),
group_data AS (SELECT
  what_race_ethnicity_best_describes_you_for_a_more_detailed_description_of_asian_,
  COUNT(Contact_Id) as student_count
FROM
  gahter_ethnicity_data
WHERE
  what_race_ethnicity_best_describes_you_for_a_more_detailed_description_of_asian_ != Ethnic_background_c
GROUP BY
  what_race_ethnicity_best_describes_you_for_a_more_detailed_description_of_asian_
  )
  

SELECT SUM(student_count)
FROM group_data