WITH gather_data AS (
  SELECT
    Contact_Id,
    CONCAT(
      "https://ctgraduates.lightning.force.com/lightning/r/Contact/",
      Contact_Id,
      "/view"
    ) AS contact_url,
    Current_Enrollment_Status__c,
    CASE
      WHEN Current_School_Type__c = "Predominantly bachelor's-degree granting" THEN " 4-Year"
      WHEN Current_School_Type__c = "Predominantly associate's-degree granting" THEN " 2-Year"
      WHEN Current_School_Type__c = "Predominantly certificate-degree granting" THEN " Less Than 2-Year"
      ELSE "Unknown"
    END AS school_type,
    PS_Internships__c,
    Fit_Type__c,
    Full_Name__c,
    Contact_Record_Type_Name,
    HIGH_SCHOOL_GRADUATING_CLASS__c,
    Most_Recent_GPA_Cumulative__c,
    Current_CC_Advisor__c,
    Grade__c,
    Attendance_Rate_Current_AS__c / 100 as attendance_rate,
    CASE
      WHEN CoVitality_Scorecard_Color_Most_Recent__c IS NULL THEN "No Data"
      ELSE CoVitality_Scorecard_Color_Most_Recent__c
    END AS CoVitality_Scorecard_Color_Most_Recent__c,
    Indicator_Low_Income__c,
    Summer_Experiences_Previous_Summer__c,
    college_applications_all_fit_types__c,
    region_short,
    CT_Coach__c,
    High_School_Text__c,
    CASE
      WHEN First_Generation_FY20__c IS NULL THEN "Missing"
      ELSE First_Generation_FY20__c
    END AS First_Generation__c,
    CASE
      WHEN Ethnic_background__c IS NULL THEN "Missing"
      ELSE Ethnic_background__c
    END AS Ethnic_background__c,
    CASE
      WHEN Gender__c IS NULL THEN "Decline to State"
      ELSE Gender__c
    END AS Gender__c,
    site_short,
    Years_Since_HS_Grad__c,
    CASE
      WHEN Attendance_Rate_Current_AS__c <= 65 THEN "65% and Below"
      WHEN Attendance_Rate_Current_AS__c < 80 THEN "65% - 79%"
      WHEN Attendance_Rate_Current_AS__c < 90 THEN "80% - 89%"
      WHEN Attendance_Rate_Current_AS__c >= 90 THEN "90% +"
      ELSE "No Data"
    END AS attendance_bucket,
    CASE
      WHEN Most_Recent_GPA_Cumulative__c <= 2.5 THEN "Below 2.5"
      WHEN Most_Recent_GPA_Cumulative__c < 2.75 THEN "2.5 - 2.74"
      WHEN Most_Recent_GPA_Cumulative__c < 3.0 THEN "2.75 - 2.99"
      WHEN Most_Recent_GPA_Cumulative__c < 3.25 THEN "3.0 - 3.24"
      WHEN Most_Recent_GPA_Cumulative__c >= 3.25 THEN "3.25+"
      ELSE "No Data"
    END AS most_recent_gpa_bucket,
    CASE
      WHEN Attendance_Rate_Current_AS__c <= 65 THEN 1
      WHEN Attendance_Rate_Current_AS__c < 80 THEN 2
      WHEN Attendance_Rate_Current_AS__c < 90 THEN 3
      WHEN Attendance_Rate_Current_AS__c >= 90 THEN 4
      ELSE 0
    END AS sort_attendance_bucket,
    CASE
      WHEN Most_Recent_GPA_Cumulative__c <= 2.5 THEN 1
      WHEN Most_Recent_GPA_Cumulative__c < 2.75 THEN 2
      WHEN Most_Recent_GPA_Cumulative__c < 3.0 THEN 3
      WHEN Most_Recent_GPA_Cumulative__c < 3.25 THEN 4
      WHEN Most_Recent_GPA_Cumulative__c >= 3.25 THEN 5
      ELSE 0
    END AS sort_most_recent_gpa_bucket,
    CASE
      WHEN ABS(Years_Since_HS_Grad__c) = 4 THEN 0 + (.33 / Year_Fraction_Since_HS_Grad__c)
      WHEN ABS(Years_Since_HS_Grad__c) = 3 THEN 4 + (.33 / Year_Fraction_Since_HS_Grad__c)
      WHEN ABS(Years_Since_HS_Grad__c) = 2 THEN 7 + (.33 / Year_Fraction_Since_HS_Grad__c)
      WHEN ABS(Years_Since_HS_Grad__c) = 1 THEN 10 + (.33 / Year_Fraction_Since_HS_Grad__c)
    END AS term_number,
    CASE
      WHEN CoVitality_Scorecard_Color_Most_Recent__c = "Red" THEN 1
      WHEN CoVitality_Scorecard_Color_Most_Recent__c = "Blue" THEN 2
      WHEN CoVitality_Scorecard_Color_Most_Recent__c = "Green" THEN 3
      ELSE 0
    END AS sort_covitality,
    Community_Service_Hours__c,
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
    Enrollment_Status__c,
    Credits_Accumulated_Most_Recent__c / 100 AS Credits_Accumulated_Most_Recent__c,
    School_Name,
    CASE
      WHEN Credit_Accumulation_Pace__c IS NULL THEN "No Data"
      ELSE Credit_Accumulation_Pace__c
    END AS Credit_Accumulation_Pace__c,
    CASE
      WHEN Latest_Reciprocal_Communication_Date__c IS NULL THEN "No Data"
      WHEN DATE_DIFF(
        CURRENT_DATE(),
        Latest_Reciprocal_Communication_Date__c,
        DAY
      ) <= 30 THEN "Less than 30 Days"
      WHEN DATE_DIFF(
        CURRENT_DATE(),
        Latest_Reciprocal_Communication_Date__c,
        DAY
      ) <= 60 THEN "30 - 60 Days"
      WHEN DATE_DIFF(
        CURRENT_DATE(),
        Latest_Reciprocal_Communication_Date__c,
        DAY
      ) > 60 THEN "60+ Days"
    END AS last_contact_range,
  FROM
    `data-warehouse-289815.sfdc_templates.contact_at_template`
  WHERE
    Current_AS__c = True
    AND College_Track_Status__c IN ('11A', '18a', '12A', '15A')
),
current_as AS (
  SELECT
    Contact_Id,
    On_Track__c
  FROM
    `data-warehouse-289815.sfdc_templates.contact_at_template`
  WHERE
    Current_AS__c = True
    AND College_Track_Status__c IN ('15A')
),
previous_as AS (
  SELECT
    Contact_Id,
    On_Track__c
  FROM
    `data-warehouse-289815.sfdc_templates.contact_at_template`
  WHERE
    Previous_AS__c = True
    AND College_Track_Status__c IN ('15A')
),
prev_prev_as AS (
  SELECT
    Contact_Id,
    On_Track__c
  FROM
    `data-warehouse-289815.sfdc_templates.contact_at_template`
  WHERE
    Prev_Prev_As__c = True
    AND College_Track_Status__c IN ('15A')
),
joined_on_track AS (
  SELECT
    CS.Contact_Id,
    CS.On_Track__c AS current_as_on_track,
    PS.On_Track__c AS previous_as_on_track,
    PPS.On_Track__c AS prev_prev_as_on_track
  FROM
    current_as CS
    LEFT JOIN previous_as PS ON PS.Contact_Id = CS.Contact_ID
    LEFT JOIN prev_prev_as PPS ON PPS.Contact_Id = CS.Contact_ID
),
most_recent_on_track AS (
  SELECT
    Contact_Id,
    CASE
      WHEN current_as_on_track IS NOT NULL THEN current_as_on_track
      WHEN previous_as_on_track IS NOT NULL THEN previous_as_on_track
      WHEN prev_prev_as_on_track IS NOT NULL THEN prev_prev_as_on_track
      ELSE NULL
    END AS most_recent_on_track
  FROM
    joined_on_track
),
modify_data AS (
  SELECT
    GD.*,
    CASE
      WHEN Overall_Rubric_Color = "Red" THEN 1
      WHEN Overall_Rubric_Color = "Yellow" THEN 2
      WHEN Overall_Rubric_Color = "Green" THEN 3
      ELSE 4
    END AS Overall_Rubric_Color_sort,
    CASE
      WHEN Credit_Accumulation_Pace__c = "4-Year Track" THEN 1
      WHEN Credit_Accumulation_Pace__c = "5-Year Track" THEN 2
      WHEN Credit_Accumulation_Pace__c = "6-Year Track" THEN 3
      WHEN Credit_Accumulation_Pace__c = "6+ Years" THEN 4
      ELSE 5
    END AS Credit_Accumulation_Pace_sort,
    CASE
      WHEN Credits_Accumulated_Most_Recent__c IS NULL THEN "Frosh"
      WHEN Credits_Accumulated_Most_Recent__c <.25 THEN "Frosh"
      WHEN Credits_Accumulated_Most_Recent__c <.5 THEN "Sophomore"
      WHEN Credits_Accumulated_Most_Recent__c <.75 THEN "Junior"
      WHEN Credits_Accumulated_Most_Recent__c >=.75 THEN "Senior"
    END AS college_class,
    CASE
      WHEN last_contact_range = "Less than 30 Days" THEN 1
      WHEN last_contact_range = "30 - 60 Days" THEN 2
      WHEN last_contact_range = "60+ Days" THEN 3
      ELSE 4
    END AS last_contact_range_sort,
    MROT.most_recent_on_track,
    CASE
      WHEN Years_Since_HS_Grad__c >= 0 THEN "N/A"
      WHEN Community_Service_Hours__c >= (8.33 * term_number) THEN "On Track"
      WHEN Community_Service_Hours__c >= ((8.33 * term_number) *.85) THEN "Near On Track"
      WHEN Community_Service_Hours__c < ((8.33 * term_number) *.85) THEN "Off Track"
      ELSE "No Data"
    END AS community_service_bucket
  FROM
    gather_data GD
    LEFT JOIN most_recent_on_track MROT ON MROT.Contact_Id = GD.Contact_ID
)
SELECT
  *,
  CASE
    WHEN community_service_bucket = "On Track" THEN 1
    WHEN community_service_bucket = "Near On Track" THEN 2
    WHEN community_service_bucket = "Off Track" THEN 3
    ELSE 0
  END AS sort_community_service_bucket,
from
  modify_data