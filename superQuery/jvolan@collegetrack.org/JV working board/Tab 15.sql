    SELECT
    cay.Contact_Id,
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