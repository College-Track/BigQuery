WITH aggregate_data AS (
  SELECT
    site_short,
    site_sort,
    region_short,
    Gender_c,
    First_Generation_c,
    Indicator_Low_Income_c,
    College_Track_Status_Name,
    Contact_Record_Type_Name,
    Ethnic_background_c,
    HIGH_SCHOOL_GRADUATING_CLASS_c,
    COUNT(Contact_Id) AS student_count,
    MAX(College_Track_FY_HS_Planned_Enrollment_c) AS budget_target,
    MAX(College_Track_High_School_Capacity_c) AS capacity_target,
  FROM
    `data-studio-260217.ct_application.ct_application_filtered_data`
  WHERE
    (
      Contact_Record_Type_Name = 'Student: High School'
    )
    OR (Created_Date >= "2020-01-15")
  GROUP BY
    site_short,
    site_sort,
    region_short,
    Gender_c,
    First_Generation_c,
    Indicator_Low_Income_c,
    College_Track_Status_Name,
    Contact_Record_Type_Name,
    HIGH_SCHOOL_GRADUATING_CLASS_c,
    Ethnic_background_c
),
applicant_count_data AS (
  SELECT
    site_short,
    SUM(applicant_count) AS applicant_count,
    SUM(onboarding_count) AS onboarding_count
  FROM
    `data-studio-260217.ct_application.ct_application_filtered_data`
  WHERE
    Created_Date >= "2020-01-15"
  GROUP BY
    site_short
),
student_count_data AS (
  SELECT
    site_short,
    SUM(current_student_count) AS current_student_count,
    
  FROM
    `data-studio-260217.ct_application.ct_application_filtered_data`
  GROUP BY
    site_short
)
SELECT
  aggregate_data.*,
  CASE
    WHEN College_Track_Status_Name = "Application in progress" THEN 1
    WHEN College_Track_Status_Name = "Application submitted" THEN 2
    WHEN College_Track_Status_Name = "Interview Scheduled" THEN 3
    WHEN College_Track_Status_Name = "Interview Complete" THEN 4
    WHEN College_Track_Status_Name = "Admitted" THEN 5
    WHEN College_Track_Status_Name = "Wait-listed" THEN 6
    WHEN College_Track_Status_Name = "Onboarding" THEN 7
    ELSE 8
  END AS sort_ct_status,
  applicant_count_data.applicant_count,
  student_count_data.current_student_count,
    applicant_count_data.onboarding_count
FROM
  aggregate_data
  LEFT JOIN applicant_count_data ON aggregate_data.site_short = applicant_count_data.site_short
  LEFT JOIN student_count_data ON aggregate_data.site_short = student_count_data.site_short