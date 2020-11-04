WITH calculate_metrics AS(
  SELECT
    *,
    CASE
      WHEN Most_Recent_GPA_Cumulative__c >= 3.25 THEN 1
      ELSE 0
    END AS met_gpa_goal,
    CASE
      WHEN CoVitality_Scorecard_Color_Most_Recent__c = "Green" THEN 1
      ELSE 0
    END AS met_covi_goal,
    CASE
      WHEN Summer_Experiences_Previous_Summer__c >= 1 THEN 1
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
      WHEN college_applications_all_fit_types__c >= 1 THEN 1
      ELSE 0
    END AS met_college_app_goal
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
    Grade__c = "12th Grade"
  GROUP BY
    region_short,
    site_short
)
SELECT
  CM.region_short,
  CM.site_short,
  CM.SITE__c,
  COUNT(CM.Contact_Id) AS student_count,
  SUM(CM.met_gpa_goal) AS met_gpa_goal,
  SUM(CM.met_covi_goal) AS met_covi_goal,
  SUM(CM.met_mse_goal) AS met_mse_goal,
  SUM(CM.met_attendance_goal) AS met_attendance_goal,
  SUM(CM.met_cs_goal) AS met_cs_goal,
  SUM(CM.met_college_app_goal) as met_college_app_goal,
  MAX(SC.senior_count) as senior_count,
  MAX(Account.College_Track_High_School_Capacity__c) AS hs_capacity,
  MAX(Account.College_Track_FY_HS_Planned_Enrollment__c) AS  hs_budget_capacity
FROM
  calculate_metrics CM
   LEFT JOIN senior_count SC ON SC.site_short = CM.site_short
    LEFT JOIN `data-warehouse-289815.salesforce_raw.Account` Account ON Account.Id = CM.SITE__c

GROUP BY
  SITE__c,
  region_short,
  site_short