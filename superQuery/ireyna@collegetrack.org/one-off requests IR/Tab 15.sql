 SELECT *
    FROM 
        (SELECT at_id AS idd,
                MAX(MAX(start_date_c)) OVER (PARTITION BY contact_id) AS start_date_c
                        FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
                        WHERE ct_status_at_c ='Active: Post-Secondary'
                        AND College_Track_Status_Name ='Inactive: Post-Secondary'
                        GROUP BY contact_id,at_id)
        WHERE at_id = idd