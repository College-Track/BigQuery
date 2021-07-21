with get_key AS
(  
    SELECT
    *
    FROM `data-studio-260217.workshop_dosage_duration_tracker.fy22_dosage_expectation_key` 
),

gather_workshop_data AS
(
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
    AND dosage_types_c IN ('Acceleration','Test Prep','Tutoring','Student Life')
)

    SELECT
    site_c,
    dosage_types_c,
    MAX(sessions_c) AS total_sessions,
    MAX(at_total_mins) AS at_total_mins,
    MAX(Total_duration_min) AS Total_duration_min,
    MAX(Total_duration_max) AS Total_duration_max,
    MAX(CASE
        WHEN Total_duration_min > at_total_mins THEN 'Less than min required dosage'
        WHEN Total_duration_max < at_total_mins THEN 'More than max required dosage'
        ELSE 'Dosage meets expectations'
    END) AS meeting_dosage_bucket
        
    FROM gather_workshop_data
    GROUP BY site_c, dosage_types_c