with 
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
    
    FROM `data-warehouse-289815.salesforce_clean.contact_template`
    WHERE college_track_status_Name = 'Inactive: Post-Secondary'
),

last_active_term AS (
    SELECT 
        * EXCEPT (row_num)
        
    FROM 
        (SELECT 
        at_id,
        contact_id,
        at_name,
        end_date_c AS last_active_term_end_date,
        ROW_NUMBER() OVER(PARTITION BY contact_id ORDER BY end_date_c DESC) AS row_num --pull last date student was active PS
        FROM `data-warehouse-289815.salesforce_clean.contact_at_template` term
        WHERE 
        ct_status_at_c ='Active: Post-Secondary'
        AND College_Track_Status_Name ='Inactive: Post-Secondary')
    WHERE row_num = 1
    GROUP BY at_id, contact_id, at_name, last_active_term_end_date
        
), 

last_term AS (
    SELECT 
        * EXCEPT (row_num)
        
    FROM 
        (SELECT 
        at_id,
        contact_id,
        at_name AS last_term,
        end_date_c AS last_available_term,
        ROW_NUMBER() OVER(PARTITION BY contact_id ORDER BY end_date_c DESC) AS row_num --pull last PAT. In case student does not have a PAT where they are active PS
        FROM `data-warehouse-289815.salesforce_clean.contact_at_template` term
        WHERE 
        AT_Record_Type_Name = 'College/University Semester'
        AND College_Track_Status_Name ='Inactive: Post-Secondary')
    WHERE row_num = 1
    GROUP BY at_id, contact_id, last_term, last_available_term
),
    
status_history AS (
    SELECT 
    DISTINCT
        contact_c,
        name AS status_history,
        MAX(MAX(start_date_c)) OVER (PARTITION BY contact_c) AS day_marked_inactive_max
    
    FROM`data-warehouse-289815.salesforce.contact_pipeline_history_c`    
    WHERE Name = 'Became Inactive Post-Secondary'
    GROUP BY name,contact_c
)
       
    SELECT 
        DISTINCT
        ps.Contact_Id,
        full_name_c,
        site_short,
        high_school_graduating_class_c,
        College_Track_Status_Name,
        grade_c,
        anticipated_date_of_graduation_ay_c,
        Total_BB_Earnings_as_of_HS_Grad_contact_c,
        Total_Bank_Book_Balance_contact_c,
        status_history,
        CASE 
            WHEN at_name IS NOT NULL 
            THEN at_name 
            WHEN last_term IS NOT NULL
            THEN last_term
            ELSE NULL
        END AS pat_name,
        
        CASE 
            WHEN status_history IS NULL 
            THEN last_active_term_end_date
            ELSE day_marked_inactive_max
        END AS approx_inactive_date,
        
        DATE_DIFF(CURRENT_DATE(), day_marked_inactive_max, DAY) AS days_since_inactive
        
    FROM inactive_college_students AS ps
    LEFT JOIN status_history AS sh
        ON ps.contact_id=sh.contact_c
    LEFT JOIN last_active_term AS term
        ON ps.contact_id=term.contact_id
    LEFT JOIN last_term as last
        ON ps.contact_id=last.contact_id
    
    GROUP BY
        Contact_Id,
        full_name_c,
        site_short,
        high_school_graduating_class_c,
        College_Track_Status_Name,
        grade_c,
        anticipated_date_of_graduation_ay_c,
        Total_BB_Earnings_as_of_HS_Grad_contact_c,
        Total_Bank_Book_Balance_contact_c,
        status_history,
        at_name,
        last_term,
        last_active_term_end_date,
        day_marked_inactive_max,
        last_available_term
        