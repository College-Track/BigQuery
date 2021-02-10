SELECT subject, who_id, id, description 
FROM `data-warehouse-289815.salesforce.task`
WHERE subject = "CT Corporate Residency Summer 2019"
AND is_deleted = FALSE