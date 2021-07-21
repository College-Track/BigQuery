 
    SELECT
    site_c,
    workshop_display_name_c,
    dosage_types_c,
    (sessions_c * duration_c) AS at_total_mins,
    sessions_c,
    duration_c,
    first_session_date_c,
    last_session_date_c,
--hardcode in the min & reccomended # of mins for each dosage type based on fy22 dosage expectations
    540 AS acceleration_min,
    675 AS acceleration_upper,
    360 AS content_support_min,
    450 AS content_support_upper,
    540 AS test_prep_min,
    675 AS test_prep_upper,
    270 AS sld_min,
    450 AS sld_upper,
    
    
    
    
    From `data-warehouse-289815.salesforce.class_c`
    WHERE global_academic_semester_c = 'a3646000000dMXoAAM'