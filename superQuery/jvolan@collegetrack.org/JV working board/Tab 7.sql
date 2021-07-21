 
    SELECT
    site_c,
    workshop_display_name_c,
    dosage_types_c,
    (sessions_c * duration_c) AS at_total_mins,
    sessions_c,
    duration_c,
    first_session_date_c,
    last_session_date_c
    
    From `data-warehouse-289815.salesforce.class_c`
    WHERE global_academic_semester_c = 'a3646000000dMXoAAM'