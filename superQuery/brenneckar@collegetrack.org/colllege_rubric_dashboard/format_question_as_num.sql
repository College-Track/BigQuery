CREATE OR REPLACE FUNCTION `data-studio-260217.college_rubric.format_question_as_num`(question STRING) 
RETURNS FLOAT64 
LANGUAGE js AS """
    if(question == null){return 0}
    else if(question == "N/A"){return null}
    else{
        answer = question.split("_").pop()
        if(answer == "G"){return 3}
        else if (answer == "Y"){return 2}
        else if (answer == "R"){return 1}
        else{return null}

    }
  ;
""";