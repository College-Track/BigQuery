WITH recent_logged_activities AS
(
    SELECT
    WhoId,
    WhatId AS Related_to,
    ActivityDate AS Date,
    Subject,
    Description,
    X18_Digit_Activity_ID__c,
    Reciprocal_Communication__c
    
    FROM `data-warehouse-289815.salesforce_raw.Task`
    WHERE CreatedDate BETWEEN DATE_SUB(CURRENT_DATE(),INTERVAL 1 MONTH) AND CURRENT_DATE()
),

student_data_with_activities AS
(
SELECT
--basic contact info & demos
    Contact_Id,
    Full_Name_c,
    site_abrev AS Site,
    region_abrev AS region,
    high_school_graduating_class_c AS HS_Class,
    College_Track_Status_Name AS CT_Status,
    Current_school_name,
    Current_HS_CT_Coach_c,
    Gender_c,
    CASE
        WHEN Ethnic_background_c = "Decline to State" THEN "Missing"
        Else Ethnic_background_c
    END AS Ethnic_background_c,
    english_language_learner_c_c AS ELL,
    student_has_iep_c AS IEP,
    first_generation_c,
    indicator_low_income_c,
    co_vitality_scorecard_color_most_recent_c,
    CASE
        WHEN Indicator_Intervention_Previous_2_ATs_c = TRUE THEN 1
        ELSE 0
    END AS intervention_prev_2,
    CASE
        WHEN indicator_high_risk_for_dismissal_c = TRUE THEN 1
        ELSE 0
        END AS high_risk_dismissal,
    of_high_school_terms_on_intervention_c,
    latest_reciprocal_communication_date_c,
    
    --primary contact info
    primary_contact_name_mobile_formula_c,
    primary_contact_email_c,
    primary_contact_mobile_c,
    primary_home_language_c,
    
    --current AT attendance & gpa data
    AT_Id,
    AT_Name,
    GAS_Name,
    AY_Name,
    AT_Grade_c,
    attendance_rate_c,
    enrolled_sessions_c,
    attended_workshops_c,
    attendance_rate_previous_term_c,
    DEP_GPA_Prev_semester_c AS prev_term_GPA,
    gpa_prev_semester_cumulative_c AS prev_CGPA,
    CASE
      WHEN DEP_GPA_Prev_semester_c < 2.75 THEN "Below 2.75"
      WHEN DEP_GPA_Prev_semester_c < 3.5 THEN "2.75 - 3.5"
      WHEN DEP_GPA_Prev_semester_c >= 3.5 THEN "3.5+"
      ELSE "Missing"
    END AS prev_term_gpa_bucket,
     CASE
      WHEN gpa_prev_semester_cumulative_c < 2.75 THEN "Below 2.75"
      WHEN gpa_prev_semester_cumulative_c < 3.5 THEN "2.75 - 3.5"
      WHEN gpa_prev_semester_cumulative_c >= 3.5 THEN "3.5+"
      ELSE "Missing"
    END AS prev_cgpa_bucket,
    CASE
        WHEN indicator_prev_gpa_below_2_75_c = TRUE THEN 1
        Else 0
    END AS intervention_AT_gpa_2_75,    
    CASE
        WHEN indicator_sem_attendance_below_65_c = TRUE THEN 1
        Else 0
    End AS intervention_AT_attendance_65,
    CASE
        WHEN indicator_prev_gpa_below_2_75_c = TRUE AND indicator_sem_attendance_below_65_c = TRUE THEN 1
        ELSE 0
    END AS intervention_AT_both,
    CASE
        WHEN indicator_prev_gpa_below_2_75_c = TRUE AND indicator_sem_attendance_below_65_c = TRUE THEN "GPA & Attendance"
        WHEN indicator_prev_gpa_below_2_75_c = TRUE AND indicator_sem_attendance_below_65_c = FALSE THEN "GPA Only"
        WHEN indicator_prev_gpa_below_2_75_c = FALSE AND indicator_sem_attendance_below_65_c = TRUE THEN "Attendance Only"
        ELSE "None"
    END AS intervention_AT_bucket,
    CASE
        WHEN indicator_student_on_intervention_c = TRUE THEN 1
        Else 0
    End AS intervention_AT,
    academic_intervention_needed_c,
    academic_intervention_received_c,
    
    recent_logged_activities.WhoId,
    recent_logged_activities.Related_to,
    recent_logged_activities.Date,
    recent_logged_activities.Subject,
    recent_logged_activities.Description,
    recent_logged_activities.X18_Digit_Activity_ID__c,
    recent_logged_activities.Reciprocal_Communication__c
    
    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    LEFT JOIN recent_logged_activities ON WhoId = Contact_Id
    WHERE current_as_c = TRUE
    AND college_track_status_c IN ("11A", "12A")
    )
    
    SELECT
    *
    FROM student_data_with_activities
    WHERE HS_Class IS NOT NULL
    
    