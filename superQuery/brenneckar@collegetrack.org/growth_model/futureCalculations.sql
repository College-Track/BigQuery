CREATE
OR REPLACE FUNCTION `learning-agendas.growth_model.calc_projected_student_count`(
start_count FLOAT64, 
FY FLOAT64, 
HS_Class FLOAT64, 
years_ahead FLOAT64,
rates ARRAY<FLOAT64>)
RETURNS ARRAY <STRING>
LANGUAGE js AS r"""
function determine_grade_index(FY, HS_Class) {
    if (HS_Class > (FY + 3)) {
        var grade_index = 0
    } else {
        var grade_index = 3 + (FY - HS_Class)
    }
    return (grade_index)

}

function futureCalculations(start_count, FY, HS_Class, years_ahead, rates) {
    var new_rates = rates
    // rates.forEach(function (rate, index) {
    //     if (index == 0) {
    //         new_rates.push(rates[0])
    //     }
    //     else {
    //         new_rates.push(rate / rates[index - 1])
    //     }
    // })
    var start_year = FY
    var end_year = start_year + years_ahead
    var count_index = 0
    var start_count_entered = false
    var grade_index = determine_grade_index(FY, HS_Class)
    var new_count = []

    while (start_year <= end_year) {
        _tmp_string = "FY" + (start_year - 2000)
        //  If the student hasn't joined yet, then 0
        if ((start_year + 3) < (HS_Class)) {
            new_count.push([_tmp_string, 0])
        }
        else {
            if (start_count_entered == false) {
                if (start_year == (FY)) {
                    new_count.push([_tmp_string, start_count])
                }
                else {
                    _tmp_count = start_count * new_rates[grade_index]
                    new_count.push([_tmp_string, _tmp_count])
                }
                start_count_entered = true
                start_year += 1
                _tmp_string = "FY" + (start_year - 2000)
            }
            if ((grade_index < 11) && (start_count_entered == true)) {

                _tmp_count = new_count[count_index][1] * new_rates[grade_index + 1]
            }
            else {
                _tmp_count = 0
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
""";