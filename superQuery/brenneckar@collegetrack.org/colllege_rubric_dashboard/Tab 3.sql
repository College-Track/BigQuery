CREATE
OR REPLACE FUNCTION `data-studio-260217.college_rubric.format_question_as_num`(question STRING) RETURNS FLOAT64 LANGUAGE js AS """
    if(question == null){return null}
    else{
    return question
    

    }
  ;
""";