
with gather_raw_data AS
(
    SELECT
    cay.Contact_Id AS student_count,
    AY_student_served,
    CASE
        WHEN ct_status_end_of_ay = "Leave of Absence" THEN 'LOA'
        ELSE AY_student_served
    END AS modified_AY_student_served_aur,
    AY_enrolled_sessions,
    AY_School_type,
    AY_enrollment_status,
    AY_Name,
    ct_status_end_of_ay,
    c.site_short,
    
    
    FROM `data-warehouse-289815.salesforce_clean.contact_ay_template` cay 
    LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_template` c ON c.Contact_Id = cay.Contact_Id
    WHERE ct_status_end_of_ay IN ('Current CT HS Student','Leave of Absence','Active: Post-Secondary','Inactive: Post-Secondary', 'CT Alumni')
    AND site_short = "Aurora"
 
  )
  
    SELECT
    site_short,
    AY_Name,
    modified_AY_student_served_aur,
    COUNT(student_count) AS student_count
    
    FROM gather_raw_data
    GROUP BY site_short, AY_Name, modified_AY_student_served_aur
    
