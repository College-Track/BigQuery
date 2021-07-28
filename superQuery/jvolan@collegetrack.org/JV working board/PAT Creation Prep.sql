-- active gather + transform
    SELECT
    Contact_Id,
    AT_Id AS previous_academic_semester,
    school_c,
    CASE
        WHEN 
        (term_c = 'Summer'
        AND enrollment_status_c IS NULL) THEN persistence_at_prev_enrollment_status_c
        ELSE enrollment_status_c
    END AS enrollment_status,
    '01246000000RNnHAAW' AS record_type_id,
    
    
  
    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    WHERE current_as_c = TRUE
    AND college_track_status_c = '15A'
    