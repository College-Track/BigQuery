SELECT full_name_c,subject, who_id, id, description 
FROM `data-warehouse-289815.salesforce.task`AS T
LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_template` AS C
ON C.Contact_Id = T.who_id
WHERE subject = "CT Corporate Residency Summer 2019"
AND T.is_deleted = FALSE