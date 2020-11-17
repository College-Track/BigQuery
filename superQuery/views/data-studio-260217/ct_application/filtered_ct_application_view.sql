SELECT
  *
FROM
  `data-studio-260217.ct_application.ct_application_filtered_data` AS Master
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
    LOWER(users.Email)=LOWER(SESSION_USER()) ) AS Permissions
ON
  Master.site_short=Permissions.site_short
  

