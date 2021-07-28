-- active gather + transform
    SELECT
    Contact_Id,
    AT_Id AS previous_academic_semester,
    school_c,
    enrollment_status_c,
    '01246000000RNnHAAW' AS record_type_id,
    
    
  
    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    WHERE current_as_c = TRUE
    AND college_track_status_c = '15A'