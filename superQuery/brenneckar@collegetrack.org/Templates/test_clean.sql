SELECT school_c, A.Name, COUNT(*)
FROM `data-warehouse-289815.salesforce.academic_semester_c`
LEFT JOIN `data-warehouse-289815.salesforce.account` A ON A.Id = school_c
GROUP BY school_c,A.Name