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