CREATE
OR REPLACE FUNCTION `data-studio-260217.college_rubric.format_question_as_num`(question STRING) RETURNS STRING LANGUAGE js AS """
    if(question == null){return null}
    else{
        answer = question.split("_").pop()
        if(answer == " G"){return 3}
        if (answer == " Y"){return 2}
        if (answer == " R"){return 1}
        else{return null}
    }
  ;
""";