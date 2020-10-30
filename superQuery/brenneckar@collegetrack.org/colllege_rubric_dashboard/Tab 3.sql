CREATE OR REPLACE FUNCTION `data-studio-260217.college_rubric.format_question_as_num`(question STRING)
RETURNS FLOAT64
LANGUAGE js AS """
    answer = question.split("_").pop()
    if(answer == "G"){return 3}
    else{return 2}
  ;
""";