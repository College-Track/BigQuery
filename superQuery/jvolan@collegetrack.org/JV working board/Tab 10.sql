SELECT
    Contact_Id,
    AT_Id,
    AT_Grade_c,
    
    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    WHERE global_academic_semester_c = 'a3646000000dMXuAAM'
    AND college_track_status_c = '11A'
    GROUP BY Contact_Id, AT_Id, AT_Grade_c