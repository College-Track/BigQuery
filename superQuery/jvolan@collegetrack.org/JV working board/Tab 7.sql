
    SELECT
    workshop_display_name_c,
    dosage_types_c,
    first_session_date_c,
    last_session_date_c,
    sessions_c,
    
    From `data-warehouse-289815.salesforce_clean.class_template`
    WHERE global_academic_semester_c = 'Spring 2020-21 (Semester)'