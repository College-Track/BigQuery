    SELECT
    c.Contact_Id,
    high_school_graduating_class_c,
    site_short,
    College_Track_Status_Name,
    AY_student_served,
    AY_name,
    
    CASE
        WHEN (AY_enrolled_sessions IS NULL 
        OR AY_enrolled_sessions = 0) THEN "No Data"
        WHEN (AY_attended_workshops / AY_enrolled_sessions) < .65 THEN "<65%"
        ELSE "90%"
    END AS attendance_bucket
    
    FROM `data-warehouse-289815.salesforce_clean.contact_ay_template` cay
    LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_template` c ON c.Contact_Id = cay.Contact_Id
    WHERE site_short IN ('Ward 8', 'The Durant Center')
    AND AY_name IN ('AY 2019-20','AY 2020-21')
    AND AY_student_served = "High School"
    