with get_key AS
(  
--finalize dosage req based on convo with BR. add AY column
    SELECT
    Dosage_type,
    CASE
        WHEN 
        (EXTRACT(MONTH FROM CURRENT_DATE()) IN (1,2,3,4,5,6)
        AND Dosage_type = "Tutoring") THEN (Total_duration_min / 2)
        ELSE Total_duration_min
    END AS Total_duration_min,
    academic_year,
    FROM `data-studio-260217.workshop_dosage_duration_tracker.fy22_dosage_expectations_key` 
    WHERE academic_year = 'AY 2021-22'
),

gather_workshop_data AS
(
    SELECT
    site_c,
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

    From `data-warehouse-289815.salesforce.class_c`
    LEFT JOIN get_key ON get_key.Dosage_type = dosage_types_c
    WHERE global_academic_semester_c = 'a3646000000dMXoAAM'
    AND dosage_types_c IN ('Acceleration','Test Prep','Tutoring','Student Life')
)

    SELECT
    site_c,
    department_c,
    dosage_types_c,
    workshop_display_name_c,
    w_id,
    sessions_c,
    duration_c,
    first_session_date_c,
    last_session_date_c,
    CASE
      WHEN Total_duration_min > at_total_mins THEN 0
        ELSE 1
    END AS meeting_dosage_yn
        
    FROM gather_workshop_data

/*could use this format to 
- display list of workshops (grouped or filtered by dosage type) that are below , above, or just not meeting requirements
- calc overall % of workshops meeting dosage requirements by site / dosage type
- count total workshops / sessions (if needed) by dosage type
*/
   

  