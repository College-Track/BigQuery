CREATE
OR REPLACE FUNCTION `learning-agendas.growth_model.calc_grad_projections`(
student_count FLOAT64, 
FY FLOAT64, 
HS_Class FLOAT64)
RETURNS ARRAY <STRING>
LANGUAGE js AS r"""
function calc_grad_projections(student_count, FY, HS_Class) {
    var rates = [.75, .5, .25, .1]
    var grade_index = (FY - HS_Class) - 4
    var alumni_count = []

    if (grade_index < 0) {
        return
    }
    else if (grade_index > 3) {
        return
    }
    else {
        _tmp_string = 'FY' + ((FY - 2000) + 1)
        _tmp_count = student_count * rates[grade_index]

        alumni_count.push([_tmp_string, _tmp_count])


        return (alumni_count)
    }
}

return (calc_grad_projections(student_count, FY, HS_Class))
""";