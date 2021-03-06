 SELECT
  Master.*
FROM
  `data-studio-260217.gpa_dashboard.filtered_gpa_data` AS Master
RIGHT JOIN (
  SELECT
    roles.site_short,
    roles.role
  FROM
    `data-warehouse-289815.salesforce_clean.user_clean` AS Users
  LEFT JOIN
    `data-warehouse-289815.roles.role_table` AS Roles
  ON
    Roles.Role_Id=Users.user_role_id
  WHERE
    LOWER(users.Email)='jpivaral@collegetrack.org') AS Permissions
ON
  Master.site_short=Permissions.site_short