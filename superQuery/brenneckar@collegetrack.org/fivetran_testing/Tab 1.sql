SELECT Count(Id)
FROM `data-warehouse-289815.salesforce.academic_semester_c`
WHEre is_deleted = false AND created_date >= '2021-01-19' AND created_date < '2021-01-22'