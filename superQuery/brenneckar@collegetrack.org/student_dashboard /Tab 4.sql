SELECT
  email,
  full_name_c,
  SPLIT(email, "@")[0OFFSET 0] test
FROM
  `data-studio-260217.student_dashboard.student_dashboard`
WHERE
  Contact_Id = '0031M000032xrocQAA'