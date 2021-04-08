SELECT
    AT_Id,
    AT_Name,
    Student_c,
    name,
    GAS_Name,
    AY_Name,
    AT_Grade_c,
    attendance_rate_c,
    Attendance_Rate_Previous_Term_c,
    enrolled_sessions_c,
    attended_workshops_c,
    DEP_GPA_Prev_semester_c AS prev_term_GPA,
    gpa_prev_semester_cumulative_c AS prev_CGPA,
   
    
    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    WHERE current_as_c = TRUE
    AND college_track_status_c IN ("11A", "12A")