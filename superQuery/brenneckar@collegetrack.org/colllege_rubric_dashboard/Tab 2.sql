SELECT Contact_Id,
question_finance_Financial_Aid_Package_score,
question_finance_Filing_Status_score,
question_academic_Study_Resources_score,
`data-studio-260217.college_rubric.calc_num_valid_questions`(TO_JSON_STRING(data), 'question_finance') AS TEST
FROM `data-studio-260217.college_rubric.filtered_college_rubric` as data
WHERE question_finance_Financial_Aid_Package_score IS NOT NULL
LIMIT 10