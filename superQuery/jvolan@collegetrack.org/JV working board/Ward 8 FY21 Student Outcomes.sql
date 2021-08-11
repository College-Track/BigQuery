WITH student_list AS
(
    SELECT
    Contact_Id,
    high_school_graduating_class_c,
    site_short,
    College_Track_Status_Name,
    
    FROM `data-warehouse-289815.salesforce_clean.contact_template`
    WHERE site_short = 'Ward 8'
    AND ay_2020_21_student_served_c = "High School Student"
),

gather_attendance AS
(
    SELECT 
    Contact_Id AS at_contact_id,
    count(attended_workshops_c),
    count(enrolled_sessions_c),
    MAX(CASE
        WHEN global_academic_semester_c = 'a3646000000dMXuAAM'THEN (attended_workshops_c / enrolled_sessions_c)
        ELSE 0
        END) AS f2020_attendance_rate,
    MAX(CASE
        WHEN global_academic_semester_c = 'a3646000000dMXoAAM'THEN (attended_workshops_c / enrolled_sessions_c)
        ELSE 0
        END) AS sp2021_attendance_rate,
    MAX(attended_workshops_c/enrolled_sessions_c) AS fall_spring_overall_attendance_rate,
    
    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    WHERE global_academic_semester_c IN ('a3646000000dMXuAAM','a3646000000dMXoAAM')
    AND site_short = 'Ward 8'
    AND ay_2020_21_student_served_c = "High School Student"
    GROUP BY Contact_Id
)

    SELECT
    *
    FROM gather_attendance