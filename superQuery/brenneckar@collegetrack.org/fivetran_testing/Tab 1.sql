SELECT COUNT(id), subject 
FROM `data-warehouse-289815.salesforce.task`
WHERE subject LIKE '%CT Corporate Residency Summer%'
GROUP BY subject