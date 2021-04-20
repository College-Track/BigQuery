SELECT 
        contact_id,
        type_c,
        semester_c,
        AY_name
        
        
    FROM `data-warehouse-289815.salesforce.student_life_activity_c` AS sl
        LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_at_template` AS c ON c.at_id = sl.semester_c
        
    WHERE sl.record_type_id = '01246000000ZNi8AAG' #Summer Experience
    AND AY_name = 'AY 2020-21'
    AND experience_meaningful_c = True
    AND status_c = 'Approved'