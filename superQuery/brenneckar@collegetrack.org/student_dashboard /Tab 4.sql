SELECT
  email,
  full_name_c,
  CONCAT(REPLACE(SPLIT(email, "@")[OFFSET(0)],".",SPLIT(email, "@")[OFFSET(1)]), "" AS test
FROM
  `data-studio-260217.student_dashboard.student_dashboard`
WHERE
  Contact_Id = '0034600001FWF7zAAH'