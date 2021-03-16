SELECT
  student_audit_status_c,
  COUNT(AT_Id)
FROM `data-warehouse-289815.salesforce_clean.contact_at_template` A_T
WHERE
  GAS_Name LIKE '%Spring 2019-20%'
  AND student_audit_status_c IN (
    'Active: Post-Secondary',
    'Current CT HS Student',
    'Leave of Absence'
  )
  
GROUP BY
  student_audit_status_c