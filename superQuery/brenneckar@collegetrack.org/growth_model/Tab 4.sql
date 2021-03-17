CREATE TEMP FUNCTION expand_array(start_count FLOAT64, FY FLOAT64, HS_Class FLOAT64)
RETURNS ARRAY <FLOAT64>
LANGUAGE js AS r"""
  var rates = [.5, .5, .5, .5, .5, .5, .5, .5, .5, .5, .5, .5]
  
  var num_iterations = HS_Class - FY
  
  var new_count = [];
  
  new_count.push(start_count * rates[1)
  
  new_count.push(new_count[0] * rates[1)
  
  return new_count;
""";


WITH numbers AS
  (SELECT 100 AS start_count, 2021 as FY, 2024 AS hs_class)



SELECT name,
FROM (
  SELECT expand_array(start_count, FY, hs_class) names
  FROM numbers
  
), UNNEST(names) name