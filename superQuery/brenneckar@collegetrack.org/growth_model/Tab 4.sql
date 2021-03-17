CREATE TEMP FUNCTION expand_array(x FLOAT64)
RETURNS ARRAY <FLOAT64>
LANGUAGE js AS r"""
  return [...Array(x).keys()];
""";


WITH numbers AS
  (SELECT 5 AS x)



SELECT name,
FROM (
  SELECT expand_array(x) names
  FROM numbers
  
), UNNEST(names) name