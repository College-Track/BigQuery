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
    CASE
    WHEN answer = "Strongly Agree" THEN 1
    WHEN answer = 'Agree' THEN 2
    WHEN answer = 'Neutral' THEN 3
    WHEN answer = 'Disagree' THEN 4
    WHEN answer = 'Strongly Disagree' THEN 5
    
    WHEN answer = "Extremely Helpful" THEN 1
    WHEN answer = 'Very Helpful' THEN 2
    WHEN answer = 'Moderately Helpful' THEN 3
    WHEN answer = 'Slightly Helpful' THEN 4
    WHEN answer = 'Not Helpful' THEN 5
    WHEN answer = "Don't discuss with CT advisor" THEN 6
    
    WHEN answer = "Extremely likely" THEN 1
    WHEN answer = 'Likely' THEN 2
    WHEN answer = 'Neutral' THEN 3
    WHEN answer = 'Not likely' THEN 4
    WHEN answer = 'Not at all likely' THEN 5
    WHEN answer = 'N/A' THEN 6

    
    WHEN answer = "Almost always" THEN 1
    WHEN answer = 'Frequently' THEN 2
    WHEN answer = 'Sometimes' THEN 3
    WHEN answer = 'Once in a while' THEN 4
    WHEN answer = 'Almost never' THEN 5

    WHEN answer = 'Extremely confident' THEN 1
    WHEN answer = 'Quiet confident' THEN 2
    WHEN answer = 'Somewhat confident' THEN 3
    WHEN answer = 'Slightly confident' THEN 4
    WHEN answer = 'Not at all confident' THEN 5
    
    WHEN answer = 'Every week' THEN 1
    WHEN answer = 'Twice a month' THEN 2
    WHEN answer = 'Once a month' THEN 3
    WHEN answer = "Once every other month" THEN 4
    WHEN answer = 'About once a year' THEN 5
    WHEN answer = "I have not had any interaction with my advisor to date / Not sure who my advisor is" THEN 6
    WHEN answer = 'I cannot predict at this point' THEN 7
    WHEN answer = 'I do not wish to be contacted by an advisor' THEN 8
    
     WHEN answer = "Extremely Interested" THEN 1
    WHEN answer = 'Very Interested' THEN 2
    WHEN answer = 'Moderately Interested' THEN 3
    WHEN answer = 'Slightly Interested' THEN 4
    WHEN answer = 'Not Interested' THEN 5
    
    ELSE NULL
  END AS sort_column
    

    FROM `data-studio-260217.surveys.fy21_ps_survey_long`
    LEFT JOIN `data-studio-260217.surveys.fy21_ps_survey_filters_clean` ON `data-studio-260217.surveys.fy21_ps_survey_filters_clean`.filter_contact_id = contact_id
)

    SELECT
    *,
    `data-studio-260217.surveys.determine_positive_answers` (answer) AS positive_answer

    FROM pssl_with_filter_data