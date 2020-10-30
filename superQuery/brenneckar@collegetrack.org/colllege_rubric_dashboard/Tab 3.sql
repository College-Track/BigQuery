CREATE
OR REPLACE FUNCTION `data-studio-260217.college_rubric.format_question_as_num`(question STRING) RETURNS STRING LANGUAGE js AS """
    if(question == null){return null}
    else{
    return question
    

    }
  ;
""";