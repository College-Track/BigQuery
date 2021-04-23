WITH pssl_with_filter_data AS
(
    SELECT
    Contact_Id,
    section,
    sub_section,
    CASE
    --shorten Q labels
        WHEN question = 'College Completion Programming during High School(Support with college applications, college exposure events, college essays, etc.)' THEN 'College Completion Programming during HS'
        WHEN question = 'Academic Programming during High School(Tutoring, ACT/SAT prep, math support, academic coaches, etc.)' THEN 'Academic Programming during HS'
        WHEN question = 'Student Life Programming(Meaningful summer experiences, community service, student dreams, passion projects, student life workshops, etc.)' THEN 'Student Life Programming'
        ELSE question
    END AS question,
    CASE
    -- clean NPS
        WHEN
        (question = 'How likely are you to recommend College Track to a student who wants to graduate college?'
        AND answer = '10 - extremely likely') THEN '10'
    --clean typos
        WHEN answer = 'ExtremelyInterested' THEN 'Extremely Interested'
        WHEN answer = 'VeryInterested' THEN 'Very Interested'
        WHEN answer = 'ModeratelyInterested' THEN 'Moderately Interested'
        WHEN answer = 'SlightlyInterested' THEN 'Slightly Interested'
        WHEN answer = 'NotInterested' THEN 'Not Interested'
        WHEN answer = 'StronglyDisagree' THEN 'Strongly Disagree'
        WHEN answer = 'StronglyAgree' THEN 'Strongly Agree'
        Else answer
    END AS answer,
    `data-studio-260217.surveys.fy21_ps_survey_filters_clean`.* except(filter_contact_id),
    `data-studio-260217.surveys.determine_positive_answers` (answer) AS positive_answer
    

    FROM `data-studio-260217.surveys.fy21_ps_survey_long`
    LEFT JOIN `data-studio-260217.surveys.fy21_ps_survey_filters_clean` ON `data-studio-260217.surveys.fy21_ps_survey_filters_clean`.filter_contact_id = contact_id
)

    SELECT
    *
    FROM pssl_with_filter_data