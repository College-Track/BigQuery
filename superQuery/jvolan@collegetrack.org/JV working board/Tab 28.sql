
    SELECT
    Contact_Id,
    site,
    on_track_c,
    credits_accumulated_c,
    term_c,
    
    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    WHERE GAS_Name IN ("Spring 2020-21", "Summer 2020-21")
    AND AT_Record_Type_Name IN ("College")