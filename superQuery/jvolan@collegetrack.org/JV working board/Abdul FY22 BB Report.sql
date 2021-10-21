SELECT
    Contact_Id,
    College_Track_Status_Name,
    high_school_graduating_class_c,
    community_service_hours_c AS bb_elig_cs_hours,
    
    FROM `data-warehouse-289815.salesforce_clean.contact_template`
    WHERE College_Track_Status_Name = "Current CT HS Student"