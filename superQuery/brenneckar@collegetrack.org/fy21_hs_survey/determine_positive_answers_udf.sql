CREATE
OR REPLACE FUNCTION `data-studio-260217.surveys.determine_positive_answers`(
  answer STRING
) RETURNS INT64 LANGUAGE js AS """
var positive_answers = [
        "Strongly Agree",
        'Agree',
        "Very Safe",
        "Extremely helpful",
        'Very helpful',
        "Extremely Excited",
        'Quite Excited',
        "Almost Always", 
        "Extremely Helpful",
        'Very Helpful',
        '10 - extremely likely',
        '9',
        'Almost always',
        'Frequently',
        'Extremely confident',
        'Quite confident',
        'Extremely likely',
        'Likely',
        'ExtremelyInterested',
        'VeryInterested',
        'StronglyAgree',
        'ExtremelyHelpful',
        'VeryHelpful'

    ]
        if (positive_answers.includes(answer)){
        return (1)
        }
        
    else if (answer == null){
        return (null)
    }    
    else{return 0}

; 
""";