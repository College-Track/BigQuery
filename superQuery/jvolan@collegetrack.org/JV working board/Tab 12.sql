SELECT 
    atc.Contact_Id
    AT_Name,
    AT_Cumulative_GPA,
    
    FROM  `data-warehouse-289815.salesforce_clean.contact_at_template` AS atc
    WHERE global_academic_semester_c IN ('Fall 2020-21 (Semester)','Fall 2020-21 (Quarter)') 
    AND indicator_completed_ct_hs_program_c = true
    AND college_track_status_c ='15A'