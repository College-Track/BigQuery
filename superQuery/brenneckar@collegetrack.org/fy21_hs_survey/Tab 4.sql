CREATE
OR REPLACE FUNCTION `data-studio-260217.surveys.determine_positive_answers`(
  answer STRING
) RETURNS FLOAT64 LANGUAGE js AS """
      var positive_answers = ["Strongly Agree",'Agree',"Very Safe","Extremely helpful",'Very helpful',"Extremely Excited",'Quite Excited',"Almost Always", "Extremely Helpful",'Very Helpful']
    if positive_answers.includes(answer){
        return (1)
        }
        
    else{return (0)}


;
    
""";