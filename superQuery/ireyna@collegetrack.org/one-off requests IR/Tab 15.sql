SELECT 
        * EXCEPT (row_num)
        
    FROM 
        (SELECT 
        at_id,
        contact_id,
        at_name,
        end_date_c AS last_available_term,
        ROW_NUMBER() OVER(PARTITION BY contact_id ORDER BY end_date_c DESC) AS row_num --pull last PAT. In case student does not have a PAT where they are active PS
        FROM `data-warehouse-289815.salesforce_clean.contact_at_template` term
        WHERE 
        AT_Record_Type_Name = 'College/University Semester'
        AND College_Track_Status_Name ='Inactive: Post-Secondary')
    WHERE row_num = 1
    GROUP BY at_id, contact_id, at_name, last_available_term