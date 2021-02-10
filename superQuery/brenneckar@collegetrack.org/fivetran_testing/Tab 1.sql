SELECT COUNT(id), subject 
FROM `data-warehouse-289815.salesforce.task`
WHERE subject LIKE '%CT Corporate Residency Summer%'
AND is_deleted = false
GROUP BY subject