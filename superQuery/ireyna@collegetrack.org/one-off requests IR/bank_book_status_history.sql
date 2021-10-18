#pull bank book for inactive college students. Pull in when they became inactive to calculate when they went inactive


    SELECT
    Contact_Id,
    full_name_c,
    site_short,
    high_school_graduating_class_c,
    College_Track_Status_Name,
    grade_c,
    anticipated_date_of_graduation_ay_c,
    Total_BB_Earnings_as_of_HS_Grad_contact_c,
    Total_Bank_Book_Balance_contact_c,
    status_history.name,
    start_date_c,
    CURRENT_DATE() - start_date_c AS days_since_inactive
    
    FROM `data-warehouse-289815.salesforce_clean.contact_template` contact 
    LEFT JOIN `data-warehouse-289815.salesforce.contact_pipeline_history_c`  status_history
        ON contact.contact_id = status_history.contact_c
    WHERE 
        college_track_status_Name = 'Inactive: Post-Secondary'
        AND status_history.Name = 'Became Inactive Post-Secondary'
        AND end_date_c IS NULL


LIMIT 10