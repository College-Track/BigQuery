with get_key AS
(  
--finalize dosage req based on convo with BR. add AY column
    SELECT
    Dosage_type AS k_dosage_type,
    Total_duration_min,
    academic_year,
    FROM `data-studio-260217.workshop_dosage_duration_tracker.fy22_dosage_expectations_key` 
    WHERE academic_year = 'AY 2021-22'
    AND Term = 'Fall'
),

get_site_name AS
(
    SELECT
    site_short,
    site_sort,
    site_c AS c_site,
    
    FROM `data-warehouse-289815.salesforce_clean.contact_template`
    GROUP BY site_c, site_short, site_sort
),
    
gather_workshop_data AS
(
    SELECT
    cl.site_c,
    department_c,
    workshop_display_name_c,
    id AS w_id,
    workshop_dosage_c,
    (sessions_c * duration_c) AS at_total_mins,
    sessions_c,
    duration_c,
    first_session_date_c,
    last_session_date_c,
    get_key.k_dosage_type,
    get_key.Total_duration_min,
    get_site_name.site_short,
    get_site_name.site_sort,
    is_deleted

    From `data-warehouse-289815.salesforce.class_c`cl
    LEFT JOIN get_key ON get_key.k_dosage_type = workshop_dosage_c
    LEFT JOIN get_site_name ON c_site = cl.site_c
    WHERE global_academic_semester_c = 'a3646000000dMXuAAM'
),

clean_workshop_data AS
(
    SELECT
    site_short,
    department_c,
    workshop_dosage_c,
    workshop_display_name_c,
    w_id,
    sessions_c,
    duration_c,
    first_session_date_c,
    last_session_date_c,
    Total_duration_min,
    at_total_mins,
    CASE
      WHEN Total_duration_min > at_total_mins THEN 0
        ELSE 1
    END AS meeting_dosage_yn,
    site_sort,
    is_deleted
        
    FROM gather_workshop_data
    WHERE is_deleted = false
),

get_student_grade AS
(
    SELECT
    Contact_Id,
    AT_grade_c,
    
    
    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    WHERE global_academic_semester_c = 'a3646000000dMXuAAM'
    AND college_track_status_c = '11A'
    GROUP BY Contact_Id, AT_Grade_c
),

advisory_grade_check AS
(   
    SELECT
    Class_c,
    workshop_display_name_c AS w_name_check,

    FROM `data-warehouse-289815.salesforce_clean.class_template`
    LEFT JOIN get_student_grade ON Contact_Id = Student_c
    WHERE global_academic_semester_c = 'a3646000000dMXuAAM'
    AND dosage_types_c = 'Advisory'
    GROUP BY Class_c, workshop_display_name_c
)
    SELECT 
    * 
    FROM clean_workshop_data
    LEFT JOIN advisory_grade_check ON Class_c = w_id
   

  