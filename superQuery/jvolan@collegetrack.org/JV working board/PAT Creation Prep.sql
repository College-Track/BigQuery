-- active gather + transform
    SELECT
    Contact_Id,
    AT_Id AS previous_academic_semester,
    school_c,
    cc_advisor_at_user_id_c AS cc_advisor_at,
    major_c,
    major_other_c,
    second_major_c,
    minor_c,
    financial_aid_package_c,
    CASE
        WHEN 
        (term_c = 'Summer'
        AND enrollment_status_c IS NULL) THEN persistence_at_prev_enrollment_status_c
        ELSE enrollment_status_c
    END AS enrollment_status,
    

    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    WHERE current_as_c = TRUE
    AND college_track_status_c = '15A'
    
/*    
-- call adv rubric udf to convert api to text, is this needed if prep is done in this way?
    
-- final step to add RT to all, global AY to all, and case statement for GAT for active + default semester for all  
    END AS enrollment_status,
    '01246000000RNnHAAW' AS record_type_id,
    -- update each summer
    'a1b46000000dRR9'AS global_academic_year,
    --update each term
    CASE 
        WHEN 
        (term_c = 'Summer'
        AND enrollment_status_c IS NULL
*/