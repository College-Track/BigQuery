SELECT name, start_date_c, end_date_c
FROM `data-warehouse-289815.salesforce.global_academic_semester_c`
WHERE name LIKE '%Spring%'
AND end_date_c < '2021-08-10'