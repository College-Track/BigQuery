SELECT
  email,
  full_name_c,
  REPLACE(SPLIT(email, "@")[OFFSET(0)],".","") AS test
FROM
  `data-studio-260217.student_dashboard.student_dashboard`
WHERE
  full_name_c = '0034600001FWF7zAAH'