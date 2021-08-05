    SELECT
    Contact_Id,
    full_name_c,
    site_short,
    high_school_graduating_class_c,
    College_Track_Status_Name,
    Current_school_name,
    Current_School_Type_c_degree,
    Current_Major_c,
    Current_Major_specific_c,
    current_second_major_c,
    Current_Minor_c
    
    FROM `data-warehouse-289815.salesforce_clean.contact_template`
    WHERE college_track_status_c = '15A'
    AND 
    Current_Major_c Like '%Art%'
    OR Current_Major_c LIKE '%Film%'
    OR Current_Major_c LIKE '%Photography%'