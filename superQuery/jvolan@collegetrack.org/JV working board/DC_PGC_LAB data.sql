    SELECT
    c.Contact_Id,
    high_school_graduating_class_c,
    site_short,
    College_Track_Status_Name,
    AY_student_served,
    AY_name,
    
    
    FROM `data-warehouse-289815.salesforce_clean.contact_ay_template` cay
    LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_template` c ON c.Contact_Id = cay.Contact_Id
    WHERE site_short IN ('Ward 8', 'The Durant Center')
    AND AY_name IN ('AY 2019-20','AY 2020-21')