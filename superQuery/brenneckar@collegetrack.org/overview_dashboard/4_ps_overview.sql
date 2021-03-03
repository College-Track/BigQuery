WITH calculate_metrics AS(
  SELECT
    *,
    CASE
      WHEN Most_Recent_GPA_Cumulative_c >= 3.25 THEN 1
      ELSE 0
    END AS met_gpa_goal,
    CASE
      WHEN Overall_Rubric_Color = "Green" THEN 1
      ELSE 0
    END AS met_rubric_goal,
    CASE
      WHEN Current_Enrollment_Status_c = "Full-time" THEN 1
      ELSE 0
    END AS met_enrollment_goal,
    CASE
      WHEN last_contact_range = "Less than 30 Days" THEN 1
    --   WHEN last_contact_range = "30 - 60 Days" THEN 1
      ELSE 0
    END AS met_contact_goal,
    CASE
      WHEN PS_Internships_c > 0 THEN 1
      ELSE 0
    END AS met_internship_goal,
    CASE
      WHEN most_recent_on_track = "On-Track" THEN 1
      ELSE 0
    END AS met_on_track_goal,
    CASE
      WHEN Fit_Type_c = "Best Fit" THEN 1
      WHEN Fit_Type_c = "Situational Best Fit" THEN 1
      ELSE 0
    END AS met_fit_type_goal,
    CASE
      WHEN valid_gpa_status = 'Active: Post-Secondary' THEN 1
      ELSE 0
    END AS count_gpa,
    CASE
      WHEN valid_gpa >= 3.25 THEN 1
      ELSE 0
    END AS met_gpa_goal_valid
  FROM
    `data-studio-260217.rosters.filtered_roster`
  WHERE
    Contact_Record_Type_Name = "Student: Post-Secondary"
)
SELECT
  CM.region_short,
  CM.site_short,
  COUNT(CM.Contact_Id) AS student_count,
  SUM(CM.met_gpa_goal) AS met_gpa_goal,
  SUM(CM.met_rubric_goal) AS met_rubric_goal,
  SUM(CM.met_enrollment_goal) AS met_enrollment_goal,
  SUM(CM.met_contact_goal) AS met_contact_goal,
  SUM(CM.met_internship_goal) AS met_internship_goal,
  SUM(CM.met_fit_type_goal) as met_fit_type_goal,
  SUM(CM.met_on_track_goal) as met_on_track_goal,
  SUM(CM.met_gpa_goal_valid) AS met_gpa_goal_valid,
  SUM(CM.count_gpa) AS count_gpa
FROM
  calculate_metrics CM
GROUP BY
  region_short,
  site_short