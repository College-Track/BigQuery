SELECT grade_c, COUNT(Id), RT.name
FROM `data-warehouse-289815.salesforce.contact`
LEFT JOIN `data-warehouse-289815.salesforce.record_type` RT ON record_type_id = RT.id
GROUP BY RT.name, grade_c