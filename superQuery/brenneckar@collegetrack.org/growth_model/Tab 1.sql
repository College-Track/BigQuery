SELECT
  region_short,
  site_short,
  Contact_Id,
  AT_grade_c
FROM
  `data-warehouse-289815.salesforce_clean.contact_at_template`
WHERE
  GAS_Name LIKE '%Spring 2019-20%'
  AND student_audit_status_c IN (
    'Current CT HS Student',
    'Active: Post-Secondary',
    "Leave of Absence"
  )