with get_key AS
(  
--finalize dosage req based on convo with BR. add AY column
    SELECT
    Dosage_type,
    Total_duration_min,
    academic_year,
    FROM `data-studio-260217.workshop_dosage_duration_tracker.fy22_dosage_expectations_key` 
    WHERE academic_year = 'AY 2021-22'
    AND Term = 'Spring'
),

get_site_name AS
(
    SELECT
    MAX(site_short) AS site_short,
    site_c AS c_site,
    
    FROM `data-warehouse-289815.salesforce_clean.contact_template`
    GROUP BY site_c
),
    
gather_workshop_data AS
(
    SELECT
    cl.site_c,
    department_c,
    workshop_display_name_c,
    id AS w_id,
    dosage_types_c,
    (sessions_c * duration_c) AS at_total_mins,
    sessions_c,
    duration_c,
    first_session_date_c,
    last_session_date_c,
    get_key.Dosage_type,
    get_key.Total_duration_min,
    get_site_name.site_short

    From `data-warehouse-289815.salesforce.class_c`cl
    LEFT JOIN get_key ON get_key.Dosage_type = dosage_types_c
    LEFT JOIN get_site_name ON c_site = cl.site_c
    WHERE global_academic_semester_c = 'a3646000000dMXoAAM'
    AND dosage_types_c IN ('Acceleration','Test Prep','Tutoring','Student Life')
)

    SELECT
    site_short,
    department_c,
    dosage_types_c,
    workshop_display_name_c,
    w_id,
    sessions_c,
    duration_c,
    first_session_date_c,
    last_session_date_c,
    Total_duration_min,
    CASE
      WHEN Total_duration_min > at_total_mins THEN 0
        ELSE 1
    END AS meeting_dosage_yn
        
    FROM gather_workshop_data

   

  