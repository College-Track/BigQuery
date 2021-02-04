
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
    Ethnic_background_c,
    english_language_learner_c_c,
    student_has_iep_c,
    first_generation_c,
    indicator_low_income_c,
    co_vitality_scorecard_color_most_recent_c,
    Indicator_Intervention_Previous_2_ATs_c AS intervention_prev_2,
    indicator_high_risk_for_dismissal_c AS high_risk_dismissal,
    of_high_school_terms_on_intervention_c,
    latest_reciprocal_communication_date_c,
    
    --primary contact info
    primary_contact_c,
    primary_contact_email_address_c,
    primary_contact_mobile_c,
    primary_home_language_c
    
    --current AT attendance & gpa data
    AT_Id,
    AT_Name,
    global_academic_semester_c,
    academic_year_c,
    AT_Grade_c,
    attendance_rate_c,
    enrolled_sessions_c,
    attended_workshops_c,
    attendance_rate_previous_term_c,
    AT_Term_GPA,
    AT_Term_GPA_bucket,
    AT_Cumulative_GPA,
    AT_Cumulative_GPA_bucket,
    DEP_GPA_Prev_semester_c,
    gpa_growth_prev_semester_c,
    
    gpa_bucket_running_cumulative_c,
    gpa_prev_semester_cumulative_c,
    indicator_prev_gpa_below_2_75_c,
    indicator_sem_attendance_below_65_c,
    indicator_student_on_intervention_c,
    
    academic_intervention_needed_c,
    academic_intervention_received_c
    
    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    WHERE current_as_c = TRUE
    AND college_track_status_c IN ("11A", "12A")