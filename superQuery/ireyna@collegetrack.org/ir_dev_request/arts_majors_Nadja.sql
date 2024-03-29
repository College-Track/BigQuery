 SELECT
    Contact_Id,
    full_name_c,
    site_short,
    high_school_graduating_class_c,
    College_Track_Status_Name,
    total_bank_book_balance_contact_c,
    fy_bank_book_balance_contact_c,
    Current_school_name,
    Current_School_Type_c_degree,
    Current_Major_c,
    Current_Major_specific_c,
    current_second_major_c,
    Current_Minor_c
 FROM `data-warehouse-289815.salesforce_clean.contact_template` AS contact

 WHERE 
 college_track_status_c = '15A'
 AND 
 (Current_Major_c = 'Arts: Design, Performing, or Visual'
 OR
 ((Current_school_name Like '%Art%'
 OR Current_school_name LIKE '%Film%'
 OR Current_school_name LIKE '%Photography%'
 OR Current_school_name LIKE '%Fashion%'
 OR Current_school_name LIKE '%Design%'
 OR Current_school_name LIKE '%Music%')
 OR 
 (Current_Minor_c Like '%Art%'
 OR Current_Minor_c LIKE '%Film%'
 OR Current_Minor_c LIKE '%Photography%'
 OR Current_Minor_c LIKE '%Fashion%'
 OR Current_Minor_c LIKE '%Design%'
 OR Current_Minor_c LIKE '%Music%')
 ))