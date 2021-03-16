SELECT
  student_audit_status_c,
  COUNT(A_T.Id)
FROM `data-warehouse-289815.salesforce.academic_semester_c` A_T
  LEFT JOIN `data-warehouse-289815.salesforce.global_academic_semester_c` GAS ON GAS.Id = A_T.global_academic_semester_c
WHERE
  GAS.name LIKE '%Spring 2019-20%'
  AND student_audit_status_c IN (
    'Active: Post-Secondary',
    'Current CT HS Student',
    'Leave of Absence'
  )
  AND A_T.is_deleted = false
GROUP BY
  student_audit_status_c