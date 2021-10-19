 SELECT 
        at_id,
        contact_id,
        at_name,
        MAX(MAX(end_date_c)) OVER (PARTITION BY contact_id) AS last_active_term_end_date
        
    FROM `data-warehouse-289815.salesforce_clean.contact_at_template` term
    WHERE 
        ct_status_at_c ='Active: Post-Secondary'
        AND College_Track_Status_Name ='Inactive: Post-Secondary'
    GROUP BY at_id, contact_id, at_name