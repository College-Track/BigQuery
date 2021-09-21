/*
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
    AND site_short = "Aurora"
  )
  
    SELECT
    site_short,
    AY_Name,
    AY_student_served,
    COUNT(student_count)
    
    FROM gather_raw_data
    GROUP BY site_short, AY_Name, AY_student_served
    
*/

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
    WHERE AY_student_served NOT IN ("High School", "Alumni")
    AND site_short = "Aurora"
    AND AY_Name = "AY 2020-21"