WITH gather_data AS (
  SELECT
    -- Select fields from templates
    Contact_Id,
    SITE_c,
    contact_url,
    College_Track_Status_c,
    Current_Enrollment_Status_c,
    school_type,
    PS_Internships_c,
    Fit_Type_c,
    Full_Name_c,
    Contact_Record_Type_Name,
    HIGH_SCHOOL_GRADUATING_CLASS_c,
    Current_CC_Advisor_c,
    Grade_c,
    Attendance_Rate_Current_AS_c as attendance_rate,
    Indicator_Low_Income_c,
    Summer_Experiences_Previous_Summer_c,
    college_applications_all_fit_types_c,
    region_short,
    CT_Coach_c,
    High_School_Text_c,
    first_generation_fy_20_c,
    Ethnic_background_c,
    Gender_c,
    site_short,
    Years_Since_HS_Grad_c,
    co_vitality_scorecard_color_most_recent_c,
    Most_Recent_GPA_Cumulative_c,
    Most_recent_gpa_semester_c,
    attendance_bucket_current_at,
    Community_Service_Hours_c,
    Enrollment_Status_c,
    Credits_Accumulated_Most_Recent_c / 100 AS Credits_Accumulated_Most_Recent_c,
    Current_school_name,
    Most_Recent_GPA_Cumulative_bucket,
    A_S.Name AS anticipated_date_of_graduation_4_year,
    -- Sorting fields
    sort_Most_Recent_GPA_Cumulative_bucket AS sort_most_recent_gpa_bucket,
    sort_attendance_bucket,
    sort_covitality,
    Overall_Rubric_Color_sort,
    sort_credit_accumulation_pace_c AS Credit_Accumulation_Pace_sort,
    college_class,
    
    -- Create new fields
    CASE
      WHEN ABS(Years_Since_HS_Grad_c) = 4 THEN 0 + (Year_Fraction_Since_HS_Grad_c /.33)
      WHEN ABS(Years_Since_HS_Grad_c) = 3 THEN 3 + (Year_Fraction_Since_HS_Grad_c /.33)
      WHEN ABS(Years_Since_HS_Grad_c) = 2 THEN 6 + (Year_Fraction_Since_HS_Grad_c /.33)
      WHEN ABS(Years_Since_HS_Grad_c) = 1 THEN 9 + (Year_Fraction_Since_HS_Grad_c /.33)
    END AS term_number,
    Overall_Rubric_Color,
    Credit_Accumulation_Pace_c,
    most_recent_outreach_bucket AS last_contact_range,
  FROM
    `data-warehouse-289815.salesforce_clean.contact_at_template` CAT
    LEFT JOIN `data-warehouse-289815.salesforce.global_academic_semester_c` A_S ON A_S.Id = CAT.anticipated_date_of_graduation_4_year_c
  WHERE
    CAT.Current_AS_c = True
    AND College_Track_Status_c IN ('11A', '18a', '12A', '15A')
    AND CAT.grade_c != '8th Grade'
),
current_as AS (
  SELECT
    Contact_Id,
    On_Track_c
  FROM
    `data-warehouse-289815.salesforce_clean.contact_at_template`
  WHERE
    Current_AS_c = True
    AND College_Track_Status_c IN ('15A')
),
previous_as AS (
  SELECT
    Contact_Id,
    On_Track_c
  FROM
    `data-warehouse-289815.salesforce_clean.contact_at_template`
  WHERE
    Previous_AS_c = True
    AND College_Track_Status_c IN ('15A')
),
prev_prev_as AS (
  SELECT
    Contact_Id,
    On_Track_c
  FROM
    `data-warehouse-289815.salesforce_clean.contact_at_template`
  WHERE
    Prev_Prev_As_c = True
    AND College_Track_Status_c IN ('15A')
),
joined_on_track AS (
  SELECT
    CS.Contact_Id,
    CS.On_Track_c AS current_as_on_track,
    PS.On_Track_c AS previous_as_on_track,
    PPS.On_Track_c AS prev_prev_as_on_track
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
      WHEN last_contact_range = "Less than 30 Days" THEN 1
      WHEN last_contact_range = "31 - 60 Days" THEN 2
      WHEN last_contact_range = "61+ Days" THEN 3
      ELSE 4
    END AS last_contact_range_sort,
    MROT.most_recent_on_track,
    CASE
      WHEN Years_Since_HS_Grad_c >= 0 THEN "N/A"
      WHEN Community_Service_Hours_c >= (8.33 * term_number) THEN "On Track"
      WHEN Community_Service_Hours_c >= ((8.33 * term_number) *.85) THEN "Near On Track"
      WHEN Community_Service_Hours_c < ((8.33 * term_number) *.85) THEN "Off Track"
      ELSE "No Data"
    END AS community_service_bucket
  FROM
    gather_data GD
    LEFT JOIN most_recent_on_track MROT ON MROT.Contact_Id = GD.Contact_ID
),
most_recent_complete_at_gpa AS (
  SELECT
    Contact_Id,
    AT_Cumulative_GPA_bucket,
    student_audit_status_c,
    AT_Cumulative_GPA
  FROM
    `data-warehouse-289815.salesforce_clean.contact_at_template`
  WHERE
    GAS_Name LIKE '%Fall 2020-21%'
),
final_prep AS (
  SELECT
    modify_data.*,
    CASE
      WHEN community_service_bucket = "On Track" THEN 1
      WHEN community_service_bucket = "Near On Track" THEN 2
      WHEN community_service_bucket = "Off Track" THEN 3
      ELSE 0
    END AS sort_community_service_bucket,
    MRCGPA.student_audit_status_c AS valid_gpa_status,
    MRCGPA.AT_Cumulative_GPA AS valid_gpa
  from
    modify_data
    LEFT JOIN most_recent_complete_at_gpa MRCGPA ON modify_data.Contact_Id = MRCGPA.Contact_Id
)
SELECT
  distinct *
FROM
  final_prep
