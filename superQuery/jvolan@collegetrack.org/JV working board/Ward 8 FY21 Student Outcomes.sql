    SELECT
    Contact_Id,
    high_school_graduating_class_c,
    site_short,
    College_Track_Status_Name,
    
    FROM `data-warehouse-289815.salesforce_clean.contact_template`
    WHERE site_short = 'Ward 8'
    AND ay_2020_21_student_served_c = "High School Student"