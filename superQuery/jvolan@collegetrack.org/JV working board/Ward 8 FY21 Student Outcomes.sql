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
    SUM(attended_workshops_c) AS total_attended,
    SUM(enrolled_sessions_c) AS total_enrolled,
    SUM(
        CASE 
        WHEN global_academic_semester_c = 'a3646000000dMXnAAM' THEN attended_workshops_c
        ELSE 0
        END) AS f2020_attended,
    SUM(
        CASE 
        WHEN global_academic_semester_c = 'a3646000000dMXnAAM' THEN enrolled_sessions_c
        ELSE 0
        END) AS f2020_enrolled,   
    SUM(
        CASE 
        WHEN global_academic_semester_c = 'a3646000000dMXoAAM' THEN attended_workshops_c
        ELSE 0
        END) AS sp2021_attended,
    SUM(
        CASE 
        WHEN global_academic_semester_c = 'a3646000000dMXoAAM' THEN enrolled_sessions_c
        ELSE 0
        END) AS sp2021_enrolled,   
    
    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    WHERE global_academic_semester_c IN ('a3646000000dMXnAAM','a3646000000dMXoAAM')
    AND site_short = 'Ward 8'
    AND ay_2020_21_student_served_c = "High School Student"
    GROUP BY Contact_Id
)
  

   
    SELECT
    at_contact_id,
    total_attended / total_enrolled AS f_s_overall_rate
    FROM gather_attendance

/*
    SELECT
    CASE
        WHEN f2020_attendance_rate >=.8 THEN 1 ELSE 0 END AS f2020_80,
    CASE
        WHEN f2020_attendance_rate >=.7 THEN 1 ELSE 0 END AS f2020_70,
    
    CASE
        WHEN f2020_attendance_rate >=.8 THEN 1 ELSE 0 END AS f2020_80,
    CASE
        WHEN f2020_attendance_rate >=.7 THEN 1 ELSE 0 END AS f2020_70,
    CASE
        WHEN sp2021_attendance_rate >=.8 THEN 1 ELSE 0 END AS f2020_80,
    CASE
        WHEN sp2021_attendance_rate >=.7 THEN 1 ELSE 0 END AS f2020_70,
        
    student_list.Contact_Id,
    student_list.Contact_Id
    
    
    FROM gather_attendance
    LEFT JOIN student_list ON Contact_Id = at_contact_id
    */