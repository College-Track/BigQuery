 Contact_Id,
    full_name_c,
    site_short,
    high_school_graduating_class_c,
    College_Track_Status_Name,
    grade_c,
    anticipated_date_of_graduation_ay_c,
    Total_BB_Earnings_as_of_HS_Grad_contact_c,
    Total_Bank_Book_Balance_contact_c,
    
    
    FROM `data-warehouse-289815.salesforce_clean.contact_template` contact 
    WHERE college_track_status_Name = 'Inactive: Post-Secondary'