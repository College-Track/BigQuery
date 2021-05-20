
WITH a as (SELECT * FROM UNNEST(ARRAY<STRUCT<team_kpi string, fuction_team STRING),
     b as (SELECT * FROM UNNEST(ARRAY<STRUCT<role_kpi-selected string, role STRING, function STRING) 
SELECT
  a.*
FROM
  a
LEFT JOIN
  b
ON
  (a.function_team = b.function)
WHERE
 team_kpi <> role_kpi-selected