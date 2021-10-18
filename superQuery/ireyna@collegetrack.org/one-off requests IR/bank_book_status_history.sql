#pull bank book for inactive college students. Pull in when they became inactive to calculate when they went inactive

WITH 

inactive_college_students AS (
    SELECT
    Contact_Id,
    full_name_c,
    site_short,
    high_school_graduating_class_c,
    College_Track_Status_Name,
    grade_c,
    anticipated_date_of_graduation_ay_c,
    Total_BB_Earnings_as_of_HS_Grad_contact_c,
    Total_Bank_Book_Balance_contact_c
    
    FROM `data-warehouse-289815.salesforce_clean.contact_template` contact 
    WHERE college_track_status_Name = 'Inactive: Post-Secondary'
 ),
  
  status_history AS (
    SELECT 
    DISTINCT
        contact_c,
        status_history.name AS status_history,
        MAX(MAX(start_date_c)) OVER (PARTITION BY contact_c) AS day_marked_inactive_max
    
      FROM`data-warehouse-289815.salesforce.contact_pipeline_history_c`  status_history
        
    WHERE 
        status_history.Name = 'Became Inactive Post-Secondary'
        --AND end_date_c IS NULL
    GROUP BY 
        name,
        contact_c
    )

        SELECT 
            contact.*,
            status_history,
           -- day_marked_inactive_max,
            DATE_DIFF(CURRENT_DATE(), day_marked_inactive_max, DAY) AS days_since_inactive
        FROM inactive_college_students AS contact
        LEFT JOIN status_history AS status_history
            ON contact.contact_id = status_history.contact_c