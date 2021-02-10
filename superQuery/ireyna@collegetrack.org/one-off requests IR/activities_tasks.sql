SELECT 
full_name_c,
who_id AS contact_id_task,  
subject, 
what_id AS academic_term_task, 
#id,
#description,
#T.created_date,

FROM `data-warehouse-289815.salesforce.task`AS T
LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_at_template` AS C
ON C.AT_id = T.what_id
WHERE subject = "CT Corporate Residency Summer 2020"
AND T.is_deleted = FALSE
AND site <> "College Track Arlen"
AND T.created_by_id = "00546000000bf4NAAQ" #created by Isabel


GROUP BY
full_name_c,
subject, who_id, 
what_id 
#id,