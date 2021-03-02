WITH calculate_metrics AS(
  SELECT
    *,
    CASE
      WHEN Most_Recent_GPA_Cumulative_c >= 3.25 THEN 1
      ELSE 0
    END AS met_gpa_goal,
    CASE
      WHEN co_vitality_scorecard_color_most_recent_c = "Green" THEN 1
      ELSE 0
    END AS met_covi_goal,
    CASE
      WHEN Summer_Experiences_Previous_Summer_c >= 1 THEN 1
      ELSE 0
    END AS met_mse_goal,
    CASE
      WHEN attendance_rate >=.80 THEN 1
      ELSE 0
    END AS met_attendance_goal,
    CASE
      WHEN community_service_bucket = "On Track" THEN 1
      ELSE 0
    END AS met_cs_goal,
    CASE
      WHEN college_applications_all_fit_types_c >= 1 THEN 1
      ELSE 0
    END AS met_college_app_goal,
    CASE
      WHEN valid_gpa_status = 'Current CT HS Student'
      OR valid_gpa_status = 'Leave of Absence'OR valid_gpa_status = 'Onboarding' THEN 1
      ELSE 0
    END AS count_gpa,
    CASE WHEN valid_gpa >= 3.25 THEN 1
    ELSE 0
    END AS met_gpa_goal_valid
    
  FROM 
    `data-studio-260217.rosters.filtered_roster`
  WHERE
    Contact_Record_Type_Name = "Student: High School"
),
senior_count AS (
  SELECT
    region_short,
    site_short,
    COUNT(Contact_Id) AS senior_count
  FROM
    `data-studio-260217.rosters.filtered_roster`
  WHERE
    Grade_c = "12th Grade"
  GROUP BY
    region_short,
    site_short
)
SELECT
  CM.region_short,
  CM.site_short,
  CM.SITE_c,
  COUNT(CM.Contact_Id) AS student_count,
  SUM(CM.met_gpa_goal) AS met_gpa_goal,
  SUM(CM.met_covi_goal) AS met_covi_goal,
  SUM(CM.met_mse_goal) AS met_mse_goal,
  SUM(CM.met_attendance_goal) AS met_attendance_goal,
  SUM(CM.met_cs_goal) AS met_cs_goal,
  SUM(CM.met_college_app_goal) as met_college_app_goal,
  MAX(SC.senior_count) as senior_count,
  MAX(Account.College_Track_High_School_Capacity_c) AS hs_capacity,
  MAX(Account.College_Track_FY_HS_Planned_Enrollment_c) AS hs_budget_capacity,
  SUM(CM.met_gpa_goal_valid) AS met_gpa_goal_valid,
  SUM(CM.count_gpa) AS count_gpa
FROM
  calculate_metrics CM
  LEFT JOIN senior_count SC ON SC.site_short = CM.site_short
  LEFT JOIN `data-warehouse-289815.salesforce.account` Account ON Account.Id = CM.SITE_c
GROUP BY
  SITE_c,
  region_short,
  site_short