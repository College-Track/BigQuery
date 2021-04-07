CREATE
OR REPLACE FUNCTION `learning-agendas.growth_model.calc_grad_projections`(
student_count FLOAT64, 
FY FLOAT64, 
HS_Class FLOAT64,
region STRING, 
rates ARRAY <FLOAT64>,
improve_grad_rate FLOAT64)
RETURNS ARRAY <STRING>
LANGUAGE js AS r"""

function calc_grad_projections(student_count, FY, HS_Class, region, rates, improve_grad_rate) {
    var new_rates = rates
    // rates.forEach(function (rate, index) {
    //     if (index == 0) {
    //         new_rates.push(rates[0])
    //     }
    //     else {
    //         new_rates.push(rate / rates[index - 1])
    //     }
    // })
    var alumni_count = []
    var region_rates = {
        "NOR CAL": [0.31, 0.15, 0.05, 0.04, 0.04],
        "NOLA": [0.19, 0.09, 0.06, 0.02, 0.02],
        "Other": [0.3, 0.14, 0.05, 0.035, 0.035]
    }
    if (region in region_rates) {
        var grad_rates = region_rates[region]
    }
    else {
        var grad_rates = region_rates['Other']
    }

    var grad_rate_index = (FY - HS_Class) - 4

    if (HS_Class > (FY + 3)) {
        var grade_index = 0
    } else {
        var grade_index = 3 + (FY - HS_Class)
    }
    var estimated_year_1_enrollment = student_count

    if (grade_index < 7) {
        return
    }
    else if (grade_index > 11) {
        return
    }

    else {
        while (grade_index > 4) {
            estimated_year_1_enrollment /= new_rates[grade_index]
            grade_index -= 1
        }

    }

    _tmp_string = "FY" + ((FY - 2000) + 1)
    _tmp_count = estimated_year_1_enrollment * (grad_rates[grad_rate_index] + improve_grad_rate / 5)

    alumni_count.push([_tmp_string, _tmp_count, "Alumni"])

    return (alumni_count)

}
return (calc_grad_projections(student_count, FY, HS_Class, region, rates, improve_grad_rate))
""";