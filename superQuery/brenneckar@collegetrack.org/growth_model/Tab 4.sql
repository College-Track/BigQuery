CREATE TEMP FUNCTION calc_student_count(start_count FLOAT64, FY FLOAT64, HS_Class FLOAT64, years_ahead FLOAT64)
RETURNS ARRAY <FLOAT64>
LANGUAGE js AS r"""
function futureCalculations(start_count, FY, HS_Class, years_ahead) {
    var rates = [.5, .5, .5, .5, .5, .5, .5, .5, .5, .5, .5, .5]
    var start_year = FY - 2000
    var end_year = start_year + years_ahead

    // var num_iterations = 14 - (HS_Class - FY)
    var grade_index = 3 + (FY - HS_Class)
    var new_count = [];
    var count_index = 0
    new_count.push(["FY" + start_year, start_count])
    start_year += 1
    while (start_year <= end_year) {

        _tmp_string = "FY" + start_year
        if (grade_index < 11) {
            _tmp_count = new_count[count_index][1] * rates[grade_index + 1]
        }
        else {
            _tmp_count = NaN
        }
        var _tmp_array = [_tmp_string, _tmp_count]

        new_count.push(_tmp_array)
        grade_index += 1
        count_index += 1
        start_year += 1

    }
    // var expand_by = years_ahead - new_count.length + 1
    // var extra_items = Array(expand_by).fill(NaN)

    // var final_array = new_count.concat(extra_items)
    // console.log(num_iterations)


    return (new_count)
}
return (futureCalculations(start_count, FY, HS_Class, years_ahead))
""";



CREATE TEMP FUNCTION list_fy(FY FLOAT64, years_ahead FLOAT64)
RETURNS ARRAY <STRING>
LANGUAGE js AS r"""
  function list_fiscal_years(FY, years_ahead) {
    var start_year = FY - 2000
    var end_year = start_year + years_ahead

    var fy_list = [];
    while (start_year <= end_year) {
        // console.log(grade_index)
        _tmp_string = "FY" + start_year

        fy_list.push(_tmp_string)
        start_year += 1

    }


    return (fy_list)
}
return (list_fiscal_years(FY, years_ahead))
""";







WITH numbers AS
  (SELECT 'nola' as site, 100 AS start_count, 2021 as FY, 2024 AS hs_class)
--   UNION ALL 
--   SELECT 'co' as site, 100 AS start_count, 2021 as FY, 2024 AS hs_class)



SELECT site, hs_class, student_count
FROM (
  SELECT site, hs_class, calc_student_count(start_count, FY, hs_class, 15) count_arrary
--   list_fy(FY, 15) fY_array
  FROM numbers
  
), UNNEST(count_arrary) student_count
-- LEFT JOIN UNNEST(fY_array) fy_list