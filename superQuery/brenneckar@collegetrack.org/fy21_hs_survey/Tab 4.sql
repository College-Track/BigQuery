CREATE
OR REPLACE FUNCTION `data-studio-260217.surveys.determine_positive_answers`(
  answer STRING
) RETURNS STRING LANGUAGE js AS """
    var positive_answers = ["Strongly Agree",'Agree',"Very Safe","Extremely helpful",'Very helpful',"Extremely Excited",'Quite Excited',"Almost Always", "Extremely Helpful",'Very Helpful']
    return answer    


;
    
""";