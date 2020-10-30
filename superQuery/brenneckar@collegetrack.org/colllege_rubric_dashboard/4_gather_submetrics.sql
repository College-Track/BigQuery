WITH sub_metric_pivot AS (
  SELECT
    *
  EXCEPT(
      sort_Advising_Rubric_Financial_Success_sort,
      sort_Advising_Rubric_Academic_Readiness_sort,
      sort_Advising_Rubric_Career_Readiness_sort,
      sort_Advising_Rubric_Wellness_sort,
      key,
      value
    ),
    submetric
  FROM
    `data-studio-260217.college_rubric.filtered_college_rubric` a,
    UNNEST(`data-warehouse-289815.UDF.unpivot`(a, 'sort_')) submetric
),
financial_questions AS (
  SELECT
    *
  EXCEPT(
      question_finance_Financial_Aid_Package_score,
      question_finance_Filing_Status_score,
      question_finance_Loans_score,
      question_finance_Ability_to_Pay_score,
      question_finance_Free_Checking_Account_score,
      question_finance_Scholarship_Requirements_score,
      question_finance_Familial_Responsibility_score,
      question_finance_eFund_score,
      question_finance_Repayment_Plan_score,
      question_finance_Loan_Exit_score,
      question_finance_Repayment_Policies_score,
      question_academic_Standing_score,
      question_academic_Study_Resources_score,
      question_academic_Course_Materials_score,
      question_academic_Transfer_2Year_Schools_Only_score,
      question_academic_Academic_Networking_50_Cred_score,
      question_academic_Academic_Networking_over_50_Credits_score,
      question_academic_Degree_Plan_score,
      question_academic_X075_Credit_Completion_Juniors_score,
      question_academic_Courseload_score,
      question_academic_X5_Credit_Completion_Seniors_score,
      question_wellness_Commitment_score,
      question_wellness_Campus_Outlook_score,
      question_wellness_Extracurricular_Activity_score,
      question_wellness_Support_Network_score,
      question_wellness_Time_Management_score,
      question_wellness_Personal_WellBeing_score,
      question_wellness_Housing_Food_score,
      question_wellness_Social_Stability_score,
      question_wellness_Oncampus_Housing_score,
      question_wellness_FamilyDependents_score,
      question_career_Finding_Opportunities_75_score,
      question_career_ResumeCover_Letter_score,
      question_career_Career_Counselor_25_credits_score,
      question_career_Career_Field_2550_credits_score,
      question_career_Resources_2550_credits_score,
      question_career_Internship_5075_credits_score,
      question_career_Internships_score,
      question_career_PostGraduate_Plans_5075_creds_score,
      question_career_Post_Graduate_Opportunities_75_cred_score,
      question_career_Alumni_Network_75_credits_score
    )
  FROM
    sub_metric_pivot,
    UNNEST(
      `data-warehouse-289815.UDF.unpivot`(sub_metric_pivot, 'question_finance_')
    ) finance
  WHERE
    submetric.key = "sort_Advising_Rubric_Financial_Success_sort"
),
academic_questions AS (
  SELECT
    *
  EXCEPT(
      question_finance_Financial_Aid_Package_score,
      question_finance_Filing_Status_score,
      question_finance_Loans_score,
      question_finance_Ability_to_Pay_score,
      question_finance_Free_Checking_Account_score,
      question_finance_Scholarship_Requirements_score,
      question_finance_Familial_Responsibility_score,
      question_finance_eFund_score,
      question_finance_Repayment_Plan_score,
      question_finance_Loan_Exit_score,
      question_finance_Repayment_Policies_score,
      question_academic_Standing_score,
      question_academic_Study_Resources_score,
      question_academic_Course_Materials_score,
      question_academic_Transfer_2Year_Schools_Only_score,
      question_academic_Academic_Networking_50_Cred_score,
      question_academic_Academic_Networking_over_50_Credits_score,
      question_academic_Degree_Plan_score,
      question_academic_X075_Credit_Completion_Juniors_score,
      question_academic_Courseload_score,
      question_academic_X5_Credit_Completion_Seniors_score,
      question_wellness_Commitment_score,
      question_wellness_Campus_Outlook_score,
      question_wellness_Extracurricular_Activity_score,
      question_wellness_Support_Network_score,
      question_wellness_Time_Management_score,
      question_wellness_Personal_WellBeing_score,
      question_wellness_Housing_Food_score,
      question_wellness_Social_Stability_score,
      question_wellness_Oncampus_Housing_score,
      question_wellness_FamilyDependents_score,
      question_career_Finding_Opportunities_75_score,
      question_career_ResumeCover_Letter_score,
      question_career_Career_Counselor_25_credits_score,
      question_career_Career_Field_2550_credits_score,
      question_career_Resources_2550_credits_score,
      question_career_Internship_5075_credits_score,
      question_career_Internships_score,
      question_career_PostGraduate_Plans_5075_creds_score,
      question_career_Post_Graduate_Opportunities_75_cred_score,
      question_career_Alumni_Network_75_credits_score
    )
  FROM
    sub_metric_pivot,
    UNNEST(
      `data-warehouse-289815.UDF.unpivot`(sub_metric_pivot, 'question_academic_')
    ) finance
  WHERE
    submetric.key = "sort_Advising_Rubric_Academic_Readiness_sort"
),
wellness_questions AS (
  SELECT
    *
  EXCEPT(
      question_finance_Financial_Aid_Package_score,
      question_finance_Filing_Status_score,
      question_finance_Loans_score,
      question_finance_Ability_to_Pay_score,
      question_finance_Free_Checking_Account_score,
      question_finance_Scholarship_Requirements_score,
      question_finance_Familial_Responsibility_score,
      question_finance_eFund_score,
      question_finance_Repayment_Plan_score,
      question_finance_Loan_Exit_score,
      question_finance_Repayment_Policies_score,
      question_academic_Standing_score,
      question_academic_Study_Resources_score,
      question_academic_Course_Materials_score,
      question_academic_Transfer_2Year_Schools_Only_score,
      question_academic_Academic_Networking_50_Cred_score,
      question_academic_Academic_Networking_over_50_Credits_score,
      question_academic_Degree_Plan_score,
      question_academic_X075_Credit_Completion_Juniors_score,
      question_academic_Courseload_score,
      question_academic_X5_Credit_Completion_Seniors_score,
      question_wellness_Commitment_score,
      question_wellness_Campus_Outlook_score,
      question_wellness_Extracurricular_Activity_score,
      question_wellness_Support_Network_score,
      question_wellness_Time_Management_score,
      question_wellness_Personal_WellBeing_score,
      question_wellness_Housing_Food_score,
      question_wellness_Social_Stability_score,
      question_wellness_Oncampus_Housing_score,
      question_wellness_FamilyDependents_score,
      question_career_Finding_Opportunities_75_score,
      question_career_ResumeCover_Letter_score,
      question_career_Career_Counselor_25_credits_score,
      question_career_Career_Field_2550_credits_score,
      question_career_Resources_2550_credits_score,
      question_career_Internship_5075_credits_score,
      question_career_Internships_score,
      question_career_PostGraduate_Plans_5075_creds_score,
      question_career_Post_Graduate_Opportunities_75_cred_score,
      question_career_Alumni_Network_75_credits_score
    )
  FROM
    sub_metric_pivot,
    UNNEST(
      `data-warehouse-289815.UDF.unpivot`(sub_metric_pivot, 'question_wellness_')
    ) finance
  WHERE
    submetric.key = "sort_Advising_Rubric_Wellness_sort"
),
career_questions AS (
  SELECT
    *
  EXCEPT(
      question_finance_Financial_Aid_Package_score,
      question_finance_Filing_Status_score,
      question_finance_Loans_score,
      question_finance_Ability_to_Pay_score,
      question_finance_Free_Checking_Account_score,
      question_finance_Scholarship_Requirements_score,
      question_finance_Familial_Responsibility_score,
      question_finance_eFund_score,
      question_finance_Repayment_Plan_score,
      question_finance_Loan_Exit_score,
      question_finance_Repayment_Policies_score,
      question_academic_Standing_score,
      question_academic_Study_Resources_score,
      question_academic_Course_Materials_score,
      question_academic_Transfer_2Year_Schools_Only_score,
      question_academic_Academic_Networking_50_Cred_score,
      question_academic_Academic_Networking_over_50_Credits_score,
      question_academic_Degree_Plan_score,
      question_academic_X075_Credit_Completion_Juniors_score,
      question_academic_Courseload_score,
      question_academic_X5_Credit_Completion_Seniors_score,
      question_wellness_Commitment_score,
      question_wellness_Campus_Outlook_score,
      question_wellness_Extracurricular_Activity_score,
      question_wellness_Support_Network_score,
      question_wellness_Time_Management_score,
      question_wellness_Personal_WellBeing_score,
      question_wellness_Housing_Food_score,
      question_wellness_Social_Stability_score,
      question_wellness_Oncampus_Housing_score,
      question_wellness_FamilyDependents_score,
      question_career_Finding_Opportunities_75_score,
      question_career_ResumeCover_Letter_score,
      question_career_Career_Counselor_25_credits_score,
      question_career_Career_Field_2550_credits_score,
      question_career_Resources_2550_credits_score,
      question_career_Internship_5075_credits_score,
      question_career_Internships_score,
      question_career_PostGraduate_Plans_5075_creds_score,
      question_career_Post_Graduate_Opportunities_75_cred_score,
      question_career_Alumni_Network_75_credits_score
    )
  FROM
    sub_metric_pivot,
    UNNEST(
      `data-warehouse-289815.UDF.unpivot`(sub_metric_pivot, 'question_career_')
    ) finance
  WHERE
    submetric.key = "sort_Advising_Rubric_Career_Readiness_sort"
),
gather_questions AS(
  SELECT
    *
  FROM
    financial_questions
  UNION ALL
  SELECT
    *
  FROM
    academic_questions
  UNION ALL
  SELECT
    *
  FROM
    wellness_questions
  UNION ALL
  SELECT
    *
  FROM
    career_questions
)
SELECT
  *
EXCEPT(submetric, key, value),
  CASE
    WHEN submetric.key = "sort_Advising_Rubric_Career_Readiness_sort" THEN "Career"
    WHEN submetric.key = "sort_Advising_Rubric_Wellness_sort" THEN "Wellness"
    WHEN submetric.key = "sort_Advising_Rubric_Academic_Readiness_sort" THEN "Academics"
    WHEN submetric.key = "sort_Advising_Rubric_Financial_Success_sort" THEN "Finance"
  END AS sub_metric,
  CASE
    WHEN submetric.value = "4" THEN "No Data"
    WHEN submetric.value = "3" THEN "Green"
    WHEN submetric.value = "2" THEN "Yellow"
    WHEN submetric.value = "1" THEN "Red"
  END AS submetric_score_color,
  submetric.value AS sub_metric_score,
  CASE
    WHEN key = "question_finance_Financial_Aid_Package_score" THEN "Financial Aid Package"
    WHEN key = "question_finance_Filing_Status_score" THEN "Filing Status"
    WHEN key = "question_finance_Loans_score" THEN "Loans"
    WHEN key = "question_finance_Ability_to_Pay_score" THEN "Ability to Pay"
    WHEN key = "question_finance_Free_Checking_Account_score" THEN "Free Checking Account"
    WHEN key = "question_finance_Scholarship_Requirements_score" THEN "Scholarship Requiremenents"
    WHEN key = "question_finance_Familial_Responsibility_score" THEN "Familial Responsibility"
    WHEN key = "question_finance_eFund_score" THEN "eFund"
    WHEN key = "question_finance_Repayment_Plan_score" THEN "Repayment Plan"
    WHEN key = "question_finance_Loan_Exit_score" THEN "Loan Exit"
    WHEN key = "question_finance_Repayment_Policies_score" THEN "Repayment Policies"
    WHEN key = "question_academic_Standing_score" THEN "Standing"
    WHEN key = "question_academic_Study_Resources_score" THEN "Study Resources"
    WHEN key = "question_academic_Course_Materials_score" THEN "Course Materials"
    WHEN key = "question_academic_Transfer_2Year_Schools_Only_score" THEN "Transfer - 2 Year Schools Only"
    WHEN key = "question_academic_Academic_Networking_50_Cred_score" THEN "Academic Networking"
    WHEN key = "question_academic_Academic_Networking_over_50_Credits_score" THEN "Academic Networking - Junior + Senior"
    WHEN key = "question_academic_Degree_Plan_score" THEN "Degree Plan"
    WHEN key = "question_academic_X075_Credit_Completion_Juniors_score" THEN "75% Credit Completion - Juniors"
    WHEN key = "question_academic_Courseload_score" THEN "Courseload"
    WHEN key = "question_academic_X5_Credit_Completion_Seniors_score" THEN "Credit Completion Seniors"
    WHEN key = "question_wellness_Commitment_score" THEN "Commitment"
    WHEN key = "question_wellness_Campus_Outlook_score" THEN "Campus Outlook"
    WHEN key = "question_wellness_Extracurricular_Activity_score" THEN "Extracurricular Activity"
    WHEN key = "question_wellness_Support_Network_score" THEN "Support Network"
    WHEN key = "question_wellness_Time_Management_score" THEN "Time Management"
    WHEN key = "question_wellness_Personal_WellBeing_score" THEN "Personal Wellbeing"
    WHEN key = "question_wellness_Housing_Food_score" THEN "Housing Food"
    WHEN key = "question_wellness_Social_Stability_score" THEN "Social Stability"
    WHEN key = "question_wellness_Oncampus_Housing_score" THEN "On Campus Housing"
    WHEN key = "question_wellness_FamilyDependents_score" THEN "Family Dependents"
    WHEN key = "question_career_Finding_Opportunities_75_score" THEN "Finding Opportunities"
    WHEN key = "question_career_ResumeCover_Letter_score" THEN "Resume/Cover Letter"
    WHEN key = "question_career_Career_Counselor_25_credits_score" THEN "Career Counselor"
    WHEN key = "question_career_Career_Field_2550_credits_score" THEN "Career Field"
    WHEN key = "question_career_Resources_2550_credits_score" THEN "Resources"
    WHEN key = "question_career_Internship_5075_credits_score" THEN "Internships 50-75% Credits"
    WHEN key = "question_career_Internships_score" THEN "Internships"
    WHEN key = "question_career_PostGraduate_Plans_5075_creds_score" THEN "Post Graduate Plans"
    WHEN key = "question_career_Post_Graduate_Opportunities_75_cred_score" THEN "Post Graduate Opportunities"
    WHEN key = "question_career_Alumni_Network_75_credits_score" THEN "Alumni Network"
    ELSE key
  END AS question,
  CASE
    WHEN value IS NULL THEN "No Data"
    WHEN value = "3" THEN "Green"
    WHEN value = "2" THEN "Yellow"
    WHEN value = "1" THEN "Red"
    ELSE "No Data"
  END AS question_color,
  value AS question_score
FROM
  gather_questions