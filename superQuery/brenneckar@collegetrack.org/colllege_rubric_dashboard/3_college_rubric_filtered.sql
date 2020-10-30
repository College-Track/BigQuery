WITH contact_at AS (
  SELECT
    Contact_Id,
    Full_Name__c,
    GAS_Name,
    Current_School_Type__c,
    CASE
      WHEN Credits_Accumulated_Most_Recent__c IS NULL THEN "Frosh"
      WHEN Credits_Accumulated_Most_Recent__c <.25 THEN "Frosh"
      WHEN Credits_Accumulated_Most_Recent__c <.5 THEN "Sophomore"
      WHEN Credits_Accumulated_Most_Recent__c <.75 THEN "Junior"
      WHEN Credits_Accumulated_Most_Recent__c >=.75 THEN "Senior"
    END AS college_class,
    CASE
      WHEN CAT.finance_score = 0 THEN "No Data"
      WHEN CAT.finance_score <= 1.66 THEN "Red"
      WHEN CAT.finance_score <= 2.22 THEN "Yellow"
      WHEN CAT.finance_score > 2.22 THEN "Green"
      ELSE "No Data"
    END AS financial_score_color,
    CASE
      WHEN CAT.academic_score = 0 THEN "No Data"
      WHEN CAT.academic_score <= 1.66 THEN "Red"
      WHEN CAT.academic_score <= 2.22 THEN "Yellow"
      WHEN CAT.academic_score > 2.22 THEN "Green"
      ELSE "No Data"
    END AS academic_score_color,
    CASE
      WHEN CAT.wellness_score = 0 THEN "No Data"
      WHEN CAT.wellness_score <= 1.66 THEN "Red"
      WHEN CAT.wellness_score <= 2.22 THEN "Yellow"
      WHEN CAT.wellness_score > 2.22 THEN "Green"
      ELSE "No Data"
    END AS wellness_score_color,
    CASE
      WHEN CAT.career_score = 0 THEN "No Data"
      WHEN CAT.career_score <= 1.66 THEN "Red"
      WHEN CAT.career_score <= 2.22 THEN "Yellow"
      WHEN CAT.career_score > 2.22 THEN "Green"
      ELSE "No Data"
    END AS career_score_color,
    overall_score_calc.total_raw_score,
    overall_score_calc.total_count,
    overall_score_calc.total_raw_score / NULLIF(overall_score_calc.total_count, 0) AS overall_score,
  FROM
    score_calculation CAT
    LEFT JOIN task ON task.WhoId = CAT.Contact_Id
    LEFT JOIN overall_score_calc ON overall_score_calc.Contact_Id = CAT.Contact_Id
    AND overall_score_calc.GAS_Name = CAT.GAS_Name
)
SELECT
  *,
  CASE
    WHEN overall_score = 0 THEN "No Data"
    WHEN overall_score <= 1.66 THEN "Red"
    WHEN overall_score <= 2.22 THEN "Yellow"
    WHEN overall_score > 2.22 THEN "Green"
    ELSE "No Data"
  END AS overall_score_color,
FROM
  joined_data