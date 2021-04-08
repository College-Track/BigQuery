SELECT
    AT_Id,
    AT_Name,
    Attendance_Rate_Previous_Term_c,
   
    
    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    WHERE current_as_c = TRUE
    AND college_track_status_c IN ("11A", "12A")