CREATE TEMP FUNCTION expand_array(start_count FLOAT64, FY FLOAT64, HS_Class FLOAT64)
RETURNS ARRAY <FLOAT64>
LANGUAGE js AS r"""
  function futureCalculations(start_count, FY, HS_Class) {
    var rates = [.5, .5, .5, .5, .5, .5, .5, .5, .5, .5, .5, .5]
    var num_iterations = 14 - (HS_Class - FY)
    var grade_index = 3 + (FY - HS_Class)
    var new_count = [];
    new_count.push(start_count)
    while (grade_index < num_iterations) {
        // console.log(grade_index)
        _tmp_count = new_count[grade_index] * rates[grade_index + 1]
        // console.log(_tmp_count)
        new_count.push(_tmp_count)
        grade_index += 1

    }


    return (new_count)
}

return (futureCalculations(start_count,FY, HS_Class))
""";


WITH numbers AS
  (SELECT 100 AS start_count, 2021 as FY, 2024 AS hs_class)



SELECT name,
FROM (
  SELECT expand_array(start_count, FY, hs_class) names
  FROM numbers
  
), UNNEST(names) name