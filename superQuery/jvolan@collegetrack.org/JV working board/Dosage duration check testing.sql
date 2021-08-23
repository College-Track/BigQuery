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
    get_site_name.site_short,
    get_site_name.site_sort,
    is_deleted

    From `data-warehouse-289815.salesforce.class_c`cl
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
    at_total_mins,
    site_sort,
    is_deleted
        
    FROM gather_workshop_data
    WHERE is_deleted = false
),

get_student_grade AS
(
    SELECT
    Contact_Id,
    AT_Id,
    AT_Grade_c,
    global_academic_semester_c,
    
    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    WHERE global_academic_semester_c = 'a3646000000dMXuAAM'
    AND college_track_status_c = '11A'
    GROUP BY Contact_Id, AT_Id, AT_Grade_c, global_academic_semester_c
),

get_dosage_type AS
(
    SELECT
    Class_c AS d_class,
    dosage_types_c, 
    
    FROM `data-warehouse-289815.salesforce_clean.class_template`
),

get_enrollments AS
(
    SELECT
    Class_c AS e_class,
    academic_semester_c,
    get_student_grade.AT_Grade_c,
    get_student_grade.global_academic_semester_c,
    get_dosage_type.dosage_types_c,

    FROM `data-warehouse-289815.salesforce.class_registration_c`
    LEFT JOIN get_student_grade ON AT_Id = academic_semester_c
    LEFT JOIN get_dosage_type ON d_class = Class_c
    WHERE status_c = "Enrolled"
),

clean_advisory_grade AS
(
    SELECT
    * except (academic_semester_c)
    
    FROM get_enrollments
    WHERE global_academic_semester_c = "a3646000000dMXuAAM"
    AND dosage_types_c = "Advisory"
    GROUP BY e_class, AT_Grade_c,global_academic_semester_c, dosage_types_c
),
    
join_all AS
(
    SELECT
    *,
    clean_advisory_grade.AT_Grade_c AS AT_grade
    
    FROM clean_workshop_data
    LEFT JOIN clean_advisory_grade ON e_class = w_id
),

dosage_key_join AS
(
    SELECT
    * except (workshop_dosage_c),
    CASE
        WHEN 
        (workshop_dosage_c = "Advisory"
        AND (workshop_display_name_c LIKE "%Senior%"
        OR AT_Grade = "12th Grade")) THEN "Senior Advisory"
        WHEN
        (workshop_dosage_c = "Advisory"
        AND (workshop_display_name_c LIKE "%Junior%"
        OR AT_Grade = "11th Grade")) THEN "Junior Advisory"

        ELSE workshop_dosage_c
        END AS clean_dosage_type,
        
    FROM join_all
    
)
    SELECT
    *, 
    CASE
      WHEN Total_duration_min > at_total_mins THEN 0
        ELSE 1
    END AS meeting_dosage_yn,
    
    FROM dosage_key_join
    LEFT JOIN get_key ON get_key.k_dosage_type = clean_dosage_type

    