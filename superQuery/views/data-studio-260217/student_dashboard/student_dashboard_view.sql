SELECT
  Master.*
FROM
  `data-studio-260217.student_dashboard.student_dashboard` AS Master
WHERE
  LOWER(Master.Email) = LOWER(SESSION_USER())