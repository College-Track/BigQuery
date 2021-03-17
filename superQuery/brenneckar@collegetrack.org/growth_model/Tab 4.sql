CREATE TEMP FUNCTION expand_array(x FLOAT64)
RETURNS ARRAY <FLOAT64>
LANGUAGE js AS r"""
  return [...Array(x).keys()];
""";


WITH numbers AS
  (SELECT 5 AS x, 5 as y)
SELECT x, y, expand_array(x) as products
FROM numbers;