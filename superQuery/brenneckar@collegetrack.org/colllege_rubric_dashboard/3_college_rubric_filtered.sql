WITH contact_at AS (
  SELECT
    Contact_Id,
    Full_Name__c,
    GAS_Name,
    Current_School_Type__c,
    CASE
      WHEN Current_School_Type__c = "Predominantly bachelor's-degree granting" THEN " 4-Year"
      WHEN Current_School_Type__c = "Predominantly associate's-degree granting" THEN " 2-Year"
      WHEN Current_School_Type__c = "Predominantly certificate-degree granting" THEN " Less Than 2-Year"
      ELSE "Unknown"
    END AS school_type,
    CASE
      WHEN Current_AS__c = True THEN "Current AT"
      WHEN Previous_AS__c = True THEN "Previous AT"
    END AS Current_or_Prev_At,
    site_short,
    region_short,
    Anticipated_Date_of_Graduation_AY__c,
    Current_CC_Advisor__c,
    Grade__c,
    Current_School__c,
    Fit_Type__c,
    GPA_Cumulative__c,
    CASE
      WHEN GPA_Cumulative__c < 3 THEN "Below 3.0"
      WHEN GPA_Cumulative__c < 3.25 THEN "3.0 - 3.24"
      WHEN GPA_Cumulative__c >= 3.25 THEN "3.25+"
      ELSE "Missing"
    END AS CGPA_11th_bucket,
    HIGH_SCHOOL_GRADUATING_CLASS__c,
    Most_Recent_GPA_Semester__c,
    CASE
      WHEN Most_Recent_GPA_Semester__c < 3 THEN "Below 3.0"
      WHEN Most_Recent_GPA_Semester__c < 3.25 THEN "3.0 - 3.24"
      WHEN Most_Recent_GPA_Semester__c >= 3.25 THEN "3.25+"
      ELSE "Missing"
    END AS Most_Recent_GPA_Semester_bucket,
    Most_Recent_GPA_Cumulative__c,
    CASE
      WHEN Most_Recent_GPA_Cumulative__c < 3 THEN "Below 3.0"
      WHEN Most_Recent_GPA_Cumulative__c < 3.25 THEN "3.0 - 3.24"
      WHEN Most_Recent_GPA_Cumulative__c >= 3.25 THEN "3.25+"
      ELSE "Missing"
    END AS Most_Recent_GPA_Cumulative_bucket,
    CASE
      WHEN (
        Advising_Rubric_Academic_Readiness__c = "Red"
        OR Advising_Rubric_Career_Readiness__c = 'Red'
        OR Advising_Rubric_Financial_Success__c = "Red"
        OR Advising_Rubric_Wellness__c = "Red"
      ) THEN "Red"
      WHEN (
        Advising_Rubric_Academic_Readiness__c = "Yellow"
        OR Advising_Rubric_Career_Readiness__c = 'Yellow'
        OR Advising_Rubric_Financial_Success__c = "Yellow"
        OR Advising_Rubric_Wellness__c = "Yellow"
      ) THEN "Yellow"
      WHEN (
        Advising_Rubric_Academic_Readiness__c = "Green"
        OR Advising_Rubric_Career_Readiness__c = 'Green'
        OR Advising_Rubric_Financial_Success__c = "Green"
        OR Advising_Rubric_Wellness__c = "Green"
      ) THEN "Green"
      ELSE "No Data"
    END AS Overall_Rubric_Color,
    Advising_Rubric_Academic_Readiness__c,
    Advising_Rubric_COVID__c,
    Advising_Rubric_Career_Readiness__c,
    Advising_Rubric_Financial_Success__c,
    Advising_Rubric_Wellness__c,
    Credit_Accumulation_Pace__c,
    -- Individual Questions
    Financial_Aid_Package__c,
    `data-studio-260217.college_rubric.format_question_as_num`(Financial_Aid_Package__c) AS question_finance_Financial_Aid_Package_score,
    Filing_Status__c,
    `data-studio-260217.college_rubric.format_question_as_num`(Filing_Status__c) AS question_finance_Filing_Status_score,
    Loans__c,
    `data-studio-260217.college_rubric.format_question_as_num`(Filing_Status__c) AS question_finance_Loans_score,
    Ability_to_Pay__c,
    `data-studio-260217.college_rubric.format_question_as_num`(Ability_to_Pay__c) AS question_finance_Ability_to_Pay_score,
    Free_Checking_Account__c,
    `data-studio-260217.college_rubric.format_question_as_num`(Free_Checking_Account__c) AS question_finance_Free_Checking_Account_score,
    Scholarship_Requirements__c,
    `data-studio-260217.college_rubric.format_question_as_num`(Scholarship_Requirements__c) AS question_finance_Scholarship_Requirements_score,
    Familial_Responsibility__c,
    `data-studio-260217.college_rubric.format_question_as_num`(Familial_Responsibility__c) AS question_finance_Familial_Responsibility_score,
    eFund__c,
    `data-studio-260217.college_rubric.format_question_as_num`(eFund__c) AS question_finance_eFund_score,
    Repayment_Plan__c,
    `data-studio-260217.college_rubric.format_question_as_num`(Repayment_Plan__c) AS question_finance_Repayment_Plan_score,
    Loan_Exit__c,
    `data-studio-260217.college_rubric.format_question_as_num`(Loan_Exit__c) AS question_finance_Loan_Exit_score,
    Repayment_Policies__c,
    `data-studio-260217.college_rubric.format_question_as_num`(Repayment_Policies__c) AS question_finance_Repayment_Policies_score,
    Standing__c,
    `data-studio-260217.college_rubric.format_question_as_num`(Standing__c) AS question_academic_Standing_score,
    Study_Resources__c,
    `data-studio-260217.college_rubric.format_question_as_num`(Study_Resources__c) AS question_academic_Study_Resources_score,
    Course_Materials__c,
    `data-studio-260217.college_rubric.format_question_as_num`(Course_Materials__c) AS question_academic_Course_Materials_score,
    Transfer_2Year_Schools_Only__c,
    `data-studio-260217.college_rubric.format_question_as_num`(Transfer_2Year_Schools_Only__c) AS question_academic_Transfer_2Year_Schools_Only_score,
    Academic_Networking_50_Cred__c,
    `data-studio-260217.college_rubric.format_question_as_num`(Academic_Networking_50_Cred__c) AS question_academic_Academic_Networking_50_Cred_score,
    Degree_Plan__c,
    `data-studio-260217.college_rubric.format_question_as_num`(Degree_Plan__c) AS question_academic_Degree_Plan_score,
    X075_Credit_Completion_Juniors__c,
    `data-studio-260217.college_rubric.format_question_as_num`(X075_Credit_Completion_Juniors__c) AS question_academic_X075_Credit_Completion_Juniors_score,
    Courseload__c,
    `data-studio-260217.college_rubric.format_question_as_num`(Courseload__c) AS question_academic_Courseload_score,
    X5_Credit_Completion_Seniors__c,
    `data-studio-260217.college_rubric.format_question_as_num`(X5_Credit_Completion_Seniors__c) AS question_academic_X5_Credit_Completion_Seniors_score,
    Commitment__c,
    `data-studio-260217.college_rubric.format_question_as_num`(Commitment__c) AS question_wellness_Commitment_score,
    Campus_Outlook__c,
    `data-studio-260217.college_rubric.format_question_as_num`(Campus_Outlook__c) AS question_wellness_Campus_Outlook_score,
    Extracurricular_Activity__c,
    `data-studio-260217.college_rubric.format_question_as_num`(Extracurricular_Activity__c) AS question_wellness_Extracurricular_Activity_score,
    Support_Network__c,
    `data-studio-260217.college_rubric.format_question_as_num`(Support_Network__c) AS question_wellness_Support_Network_score,
    Time_Management__c,
    `data-studio-260217.college_rubric.format_question_as_num`(Time_Management__c) AS question_wellness_Time_Management_score,
    Personal_WellBeing__c,
    `data-studio-260217.college_rubric.format_question_as_num`(Personal_WellBeing__c) AS question_wellness_Personal_WellBeing_score,
    Housing_Food__c,
    `data-studio-260217.college_rubric.format_question_as_num`(Housing_Food__c) AS question_wellness_Housing_Food_score,
    Social_Stability__c,
    `data-studio-260217.college_rubric.format_question_as_num`(Social_Stability__c) AS question_wellness_Social_Stability_score,
    Oncampus_Housing__c,
    `data-studio-260217.college_rubric.format_question_as_num`(Oncampus_Housing__c) AS question_wellness_Oncampus_Housing_score,
    FamilyDependents__c,
    `data-studio-260217.college_rubric.format_question_as_num`(FamilyDependents__c) AS question_wellness_FamilyDependents_score,
    Finding_Opportunities_75__c,
    `data-studio-260217.college_rubric.format_question_as_num`(Finding_Opportunities_75__c) AS question_career_Finding_Opportunities_75_score,
    ResumeCover_Letter__c,
    `data-studio-260217.college_rubric.format_question_as_num`(ResumeCover_Letter__c) AS question_career_ResumeCover_Letter_score,
    Career_Counselor_25_credits__c,
    `data-studio-260217.college_rubric.format_question_as_num`(Career_Counselor_25_credits__c) AS question_career_Career_Counselor_25_credits_score,
    Career_Field_2550_credits__c,
    `data-studio-260217.college_rubric.format_question_as_num`(Career_Field_2550_credits__c) AS question_career_Career_Field_2550_credits_score,
    Resources_2550_credits__c,
    `data-studio-260217.college_rubric.format_question_as_num`(Resources_2550_credits__c) AS question_career_Resources_2550_credits_score,
    Internship_5075_credits__c,
    `data-studio-260217.college_rubric.format_question_as_num`(Internship_5075_credits__c) AS question_career_Internship_5075_credits_score,
    Internships__c,
    `data-studio-260217.college_rubric.format_question_as_num`(Internships__c) AS question_career_Internships_score,
    PostGraduate_Plans_5075_creds__c,
    `data-studio-260217.college_rubric.format_question_as_num`(PostGraduate_Plans_5075_creds__c) AS question_career_PostGraduate_Plans_5075_creds_score,
    Post_Graduate_Opportunities_75_cred__c,
    `data-studio-260217.college_rubric.format_question_as_num`(Post_Graduate_Opportunities_75_cred__c) AS question_career_Post_Graduate_Opportunities_75_cred_score,
    Alumni_Network_75_credits__c,
    `data-studio-260217.college_rubric.format_question_as_num`(Alumni_Network_75_credits__c) AS question_career_Alumni_Network_75_credits_score,
    Enrollment_COVID19__c,
    CollegeUniversity_Response_COVID19__c,
    Online_Coursework_COVID19__c,
    Wellness_COVID19__c,
    -- Sorting Values
    CASE
      WHEN Advising_Rubric_Financial_Success__c = "Red" THEN 1
      WHEN Advising_Rubric_Financial_Success__c = "Yellow" THEN 2
      WHEN Advising_Rubric_Financial_Success__c = "Green" THEN 3
      ELSE 4
    END AS sort_Advising_Rubric_Financial_Success_sort,
    CASE
      WHEN Advising_Rubric_Academic_Readiness__c = "Red" THEN 1
      WHEN Advising_Rubric_Academic_Readiness__c = "Yellow" THEN 2
      WHEN Advising_Rubric_Academic_Readiness__c = "Green" THEN 3
      ELSE 4
    END AS sort_Advising_Rubric_Academic_Readiness_sort,
    CASE
      WHEN Advising_Rubric_Career_Readiness__c = "Red" THEN 1
      WHEN Advising_Rubric_Career_Readiness__c = "Yellow" THEN 2
      WHEN Advising_Rubric_Career_Readiness__c = "Green" THEN 3
      ELSE 4
    END AS sort_Advising_Rubric_Career_Readiness_sort,
    CASE
      WHEN Advising_Rubric_Wellness__c = "Red" THEN 1
      WHEN Advising_Rubric_Wellness__c = "Yellow" THEN 2
      WHEN Advising_Rubric_Wellness__c = "Green" THEN 3
      ELSE 4
    END AS sort_Advising_Rubric_Wellness_sort,
  FROM
    `data-warehouse-289815.sfdc_templates.contact_at_template`
  WHERE
    (
      Current_AS__c = TRUE
      OR Previous_AS__c = TRUE
    )
    AND AT_Record_Type_Name = "College/University Semester"
    AND Current_CT_Status__c = "Active: Post-Secondary"
),
task AS (
  SELECT
    WhoId,
    MAX(Date_of_Contact__c) as last_contact
  FROM
    `data-warehouse-289815.salesforce_raw.Task`
  GROUP BY
    WhoId
),
total_valid_questions AS(
  SELECT
    *,
    `data-studio-260217.college_rubric.calc_num_valid_questions`(TO_JSON_STRING(contact_at), 'question_finance') AS count_finance,
    `data-studio-260217.college_rubric.calc_num_valid_questions`(TO_JSON_STRING(contact_at), 'question_academic') AS count_academic,
    `data-studio-260217.college_rubric.calc_num_valid_questions`(TO_JSON_STRING(contact_at), 'question_wellness') AS count_wellness,
    `data-studio-260217.college_rubric.calc_num_valid_questions`(TO_JSON_STRING(contact_at), 'question_career') AS count_career
  FROM
    contact_at
),
score_calculation AS (
  SELECT
    *,
    `data-studio-260217.college_rubric.calc_section_score`(
      TO_JSON_STRING(total_valid_questions),
      'question_finance'
    ) / NULLIF(count_finance, 0) AS finance_score,
    `data-studio-260217.college_rubric.calc_section_score`(
      TO_JSON_STRING(total_valid_questions),
      'question_academic'
    ) / NULLIF(count_academic, 0) AS academic_score,
    `data-studio-260217.college_rubric.calc_section_score`(
      TO_JSON_STRING(total_valid_questions),
      'question_wellness'
    ) / NULLIF(count_wellness, 0) AS wellness_score,
    `data-studio-260217.college_rubric.calc_section_score`(
      TO_JSON_STRING(total_valid_questions),
      'question_career'
    ) / NULLIF(count_career, 0) AS career_score
  FROM
    total_valid_questions
),
overall_score_calc AS (
  SELECT
    Contact_Id,
    GAS_Name,
    (
      (finance_score * count_finance) + (academic_score * count_academic) + (wellness_score * count_wellness) + (career_score * count_career)
    ) / (
      count_finance + count_academic + count_wellness + count_career
    ) AS overall_score
FROM
  score_calculation
), joined_data AS (
SELECT
  CAT.* ,
  CASE
    WHEN CAT.Overall_Rubric_Color = "Red" THEN 1
    WHEN CAT.Overall_Rubric_Color = "Yellow" THEN 2
    WHEN CAT.Overall_Rubric_Color = "Green" THEN 3
    ELSE 4
  END AS Overall_Rubric_Color_sort,
  CASE
    WHEN DATE_DIFF(CURRENT_DATE(), task.last_contact, DAY) <= 30 THEN "Less than 30 Days"
    WHEN DATE_DIFF(CURRENT_DATE(), task.last_contact, DAY) <= 60 THEN "30 - 60 Days"
    WHEN DATE_DIFF(CURRENT_DATE(), task.last_contact, DAY) > 60 THEN "60+ Days"
  END AS last_contact_range,
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
  CASE
    WHEN overall_score_calc.overall_score = 0 THEN "No Data"
    WHEN overall_score_calc.overall_score <= 1.66 THEN "Red"
    WHEN overall_score_calc.overall_score <= 2.22 THEN "Yellow"
    WHEN overall_score_calc.overall_score > 2.22 THEN "Green"
    ELSE "No Data"
  END AS overall_score_color,
  overall_score_calc.overall_score
FROM
  score_calculation CAT
  LEFT JOIN task ON task.WhoId = CAT.Contact_Id
  LEFT JOIN overall_score_calc ON overall_score_calc.Contact_Id = CAT.Contact_Id
  AND overall_score_calc.GAS_Name = CAT.GAS_Name
 )
 SELECT Contact_Id, 
  finance_score,
 count_finance
 
 FROM joined_data