--with 
--inactive_college_students AS (
    SELECT
    contact.Contact_Id,
    contact.full_name_c,
    contact.site_short,
    contact.high_school_graduating_class_c,
    contact.College_Track_Status_Name,
    contact.grade_c,
    contact.anticipated_date_of_graduation_ay_c,
    contact.Total_BB_Earnings_as_of_HS_Grad_contact_c,
    contact.Total_Bank_Book_Balance_contact_c,
    MAX(MAX(start_date_c)) OVER (PARTITION BY contact.contact_id) AS last_term_active,
    term.name
    
    FROM `data-warehouse-289815.salesforce_clean.contact_template` contact 
    LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_at_template` term
        ON contact.contact_id=term.contact_id
    WHERE contact.college_track_status_Name = 'Inactive: Post-Secondary'
    
    GROUP BY
        Contact_Id,
        full_name_c,
        site_short,
        high_school_graduating_class_c,
        College_Track_Status_Name,
        grade_c,
        name,
        anticipated_date_of_graduation_ay_c,
        Total_BB_Earnings_as_of_HS_Grad_contact_c,
        Total_Bank_Book_Balance_contact_c