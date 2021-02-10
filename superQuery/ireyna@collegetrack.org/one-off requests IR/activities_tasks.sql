SELECT full_name_c,subject, who_id AS contact_id_task, id, what_id AS academic_term_task, #description 
FROM `data-warehouse-289815.salesforce.task`AS T
LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_at_template` AS C
ON C.AT_id = T.what_id
WHERE subject = "CT Corporate Residency Summer 2019"
AND T.is_deleted = FALSE
GROUP BY

full_name_c,subject, who_id, id, what_id