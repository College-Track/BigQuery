SELECT Count(( Contact_Id))
FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
WHERE college_track_status_c = '15A' AND current_as_c = true
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
    Attendance_Rate_Current_AS_c / 100 as attendance_rate,
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
    attendance_bucket_current_at,
    Community_Service_Hours_c,
    Enrollment_Status_c,
    Credits_Accumulated_Most_Recent_c / 100 AS Credits_Accumulated_Most_Recent_c,
    School_Name,
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
    AND College_Track_Status_c IN ('15A')
    AND CAT.grade_c != '8th Grade'
)


SELECT COUNT(Contact_Id)
FROM gather_data
WHERE site_short = 'Oakland'