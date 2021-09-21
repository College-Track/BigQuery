with gather_raw_data AS
(
    SELECT
    cay.Contact_Id AS student_count,
    AY_student_served,
    AY_enrolled_sessions,
    AY_School_type,
    AY_enrollment_status,
    AY_Name,
    ct_status_end_of_ay,
    c.site_short,
    
    
    FROM `data-warehouse-289815.salesforce_clean.contact_ay_template` cay 
    LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_template` c ON c.Contact_Id = cay.Contact_Id
    WHERE AY_student_served IS NOT NULL
    AND AY_Name IN ("AY 2020-21","AY 2019-20","AY 2018-19","AY 2017-18")
  )
  
    SELECT
    site_short,
    AY_student_served,
    AY_Name,
    COUNT(student_count)
    
    FROM gather_raw_data
    GROUP BY site_short, AY_Name, AY_student_served