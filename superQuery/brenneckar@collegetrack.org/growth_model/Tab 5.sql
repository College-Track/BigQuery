CREATE
OR REPLACE FUNCTION `learning-agendas.growth_model.calc_projected_student_count`(start_count FLOAT64, FY FLOAT64, HS_Class FLOAT64, years_ahead FLOAT64)
RETURNS ARRAY <STRING>
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
"""