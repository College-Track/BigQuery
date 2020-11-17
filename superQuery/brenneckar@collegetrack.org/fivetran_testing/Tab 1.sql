SELECT C.grade_c,RT.name,  COUNT(C.Id)
FROM `data-warehouse-289815.salesforce.contact` C
LEFT JOIN `data-warehouse-289815.salesforce.record_type` RT ON record_type_id = RT.id
GROUP BY RT.name, grade_c