 SELECT
  *
FROM
  `data-studio-260217.college_rubric.filtered_college_rubric` AS Master
RIGHT JOIN (
  SELECT
    roles.site_short,
    roles.role
  FROM
    `data-warehouse-289815.salesforce_raw.User` AS Users
  LEFT JOIN
    `data-warehouse-289815.roles.role_table` AS Roles
  ON
    Roles.Role_Id=Users.UserRoleId
  WHERE
    LOWER(users.Email)='lizfuentes@collegetrack.org'
    ) AS Permissions
ON
  Master.site_short=Permissions.site_short