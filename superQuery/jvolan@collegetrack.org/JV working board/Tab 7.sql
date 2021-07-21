with get_key AS
(  
    SELECT
    *
    FROM `data-studio-260217.workshop_dosage_duration_tracker.fy22_dosage_expectation_key` 
)

    SELECT
    site_c,
    workshop_display_name_c,
    dosage_types_c,
    (sessions_c * duration_c) AS at_total_mins,
    sessions_c,
    duration_c,
    first_session_date_c,
    last_session_date_c,
    get_key.Dosage_type,
    get_key.Total_duration_min,
    get_key.Total_duration_max
    
    From `data-warehouse-289815.salesforce.class_c`
    LEFT JOIN get_key ON get_key.Dosage_type = dosage_types_c
    WHERE global_academic_semester_c = 'a3646000000dMXoAAM'