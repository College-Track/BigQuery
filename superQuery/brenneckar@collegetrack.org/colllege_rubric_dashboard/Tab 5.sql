CREATE OR REPLACE FUNCTION `data-studio-260217.college_rubric.calc_num_valid_questions`(json_row STRING, col_regex STRING)
  RETURNS FLOAT64
  LANGUAGE js AS """
function count_valid_questions(obj) {
  var count = 0;
  var regex = RegExp(col_regex);

  
  for (var field in obj) {
    if (obj.hasOwnProperty(field) && obj[field] != null) {
      if (typeof obj[field] == "object") {
        count += count_valid_questions(obj[field]);
      } else if (regex.test(field)) {
        count += 1;
      }
    }
  }
  return count;
}
var row = JSON.parse(json_row);
return count_valid_questions(row);
""";