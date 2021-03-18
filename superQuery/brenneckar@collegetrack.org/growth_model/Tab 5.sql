CREATE
OR REPLACE FUNCTION `learning-agendas.growth_model.calc_projected_student_count`(
start_count FLOAT64, 
FY FLOAT64, 
HS_Class FLOAT64, 
years_ahead FLOAT64,
rates ARRAY<FLOAT64>)
RETURNS ARRAY <STRING>
LANGUAGE js AS r"""
function futureCalculations(start_count, FY, HS_Class, years_ahead, rates) {
    var start_year = FY - 2000
    var end_year = start_year + years_ahead
    if (HS_Class > (FY + 3)) {
        var grade_index = 0
    } else {
        var grade_index = 3 + (FY - HS_Class)
    }
    var new_count = [];
    var count_index = 0
    var start_count_entered = false

    while (start_year <= end_year) {
        _tmp_string = "FY" + start_year
        if ((start_year + 2000 + 3) < (HS_Class)) {
            new_count.push([_tmp_string, NaN])
        }
        else {
            if (start_count_entered == false) {
                new_count.push([_tmp_string, start_count])
                start_count_entered = true
                start_year += 1
                _tmp_string = "FY" + start_year
            }
            if ((grade_index < 11) && (start_count_entered == true)) {

                _tmp_count = new_count[count_index][1] * rates[grade_index + 1]
            }
            else {
                _tmp_count = NaN
            }
            var _tmp_array = [_tmp_string, _tmp_count]
            new_count.push(_tmp_array)
            grade_index += 1
        }
        count_index += 1
        start_year += 1
    }

    return (new_count)
}
return (futureCalculations(start_count, FY, HS_Class, years_ahead, rates))
"""