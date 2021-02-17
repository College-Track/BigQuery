WITH gather_original_emails AS (
  SELECT
    Contact_Id,
    email
  FROM
    `data-studio-260217.student_dashboard.student_dashboard`
),
create_modified_email AS (
  SELECT
    Contact_Id,
    CONCAT(
      REPLACE(SPLIT(email, "@") [OFFSET(0)], ".", ""),
      CONCAT("@", SPLIT(email, "@") [OFFSET(1)])
    ) AS email
  FROM
    `data-studio-260217.student_dashboard.student_dashboard`
),
create_union AS (
  SELECT
    *
  from
    gather_original_emails
  UNION ALL
  Select
  *
  FROM
    create_modified_email
)
SELECT distinct
  *
FROM
  create_union