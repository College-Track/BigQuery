SELECT
    u.username,
    s.schemaname,
    has_schema_privilege(u.username,s.schemaname,'create') AS user_has_select_permission,
    has_schema_privilege(u.username,s.schemaname,'usage') AS user_has_usage_permission
FROM
    pg_user u
CROSS JOIN
    (SELECT DISTINCT schemaname FROM pg_tables) s