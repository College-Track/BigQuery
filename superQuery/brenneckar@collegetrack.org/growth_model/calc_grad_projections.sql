CREATE
OR REPLACE FUNCTION `learning-agendas.growth_model.calc_grad_projections`(
student_count FLOAT64, 
FY FLOAT64, 
HS_Class FLOAT64,
region STRING)
RETURNS ARRAY <STRING>
LANGUAGE js AS r"""
function calc_grad_projections(student_count, FY, HS_Class, region) {
    var region_rates = {
        "NOR CAL": [0.31, 0.15, 0.05, 0.08],
        "NOLA": [0.19, 0.09, 0.06, 0.04],
        "Other": [0.3, 0.14, 0.05, 0.07]
    };
    if (region in region_rates) {
        var rates = region_rates[region]
    }
    else {
        var rates = region_rates['Other']
    }
    var grade_index = (FY - HS_Class) - 4
    var alumni_count = []

    if (grade_index < 0) {
        return
    }
    else if (grade_index > 3) {
        return
    }
    else {
        _tmp_string = "FY" + ((FY - 2000) + 1)
        _tmp_count = student_count * rates[grade_index]

        alumni_count.push([_tmp_string, _tmp_count, "Alumni"])


        return (alumni_count)
    }
}
return (calc_grad_projections(student_count, FY, HS_Class, region))
"""