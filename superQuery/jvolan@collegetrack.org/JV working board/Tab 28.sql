
    SELECT
    Contact_Id,
    site,
    on_track_c,
    credits_accumulated_c,
    term_c,
    
    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    WHERE AY_Name = "AY 2020-21"
    AND AT_Record_Type_Name = "College/University Semester"
    AND term_c = "Spring"
    OR (term_c = "Summer"
    AND credits_accumulated_c >0)