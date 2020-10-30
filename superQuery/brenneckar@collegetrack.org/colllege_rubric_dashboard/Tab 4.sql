WITH Input AS (
  SELECT STRUCT(1 AS foo, 2 AS bar, STRUCT('foo' AS x, 3.14 AS foo) AS baz) AS s, 10 AS foo UNION ALL
  SELECT NULL, 4 AS foo UNION ALL
  SELECT STRUCT(NULL, 2 AS bar, STRUCT('fizz' AS x, 1.59 AS foo) AS baz) AS s, NULL AS foo
)

SELECT * FROM Input