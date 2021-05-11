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
        WHEN question = "Most students I met were focused on getting a bachelor's degreeHelp note: if remote, think of the students you've met virtually via zoom, online class, study groups, office hours, etc." THEN "Most students I met were focused on getting a bachelor's degree"
        WHEN question = "I felt I belonged on my college campusHelp note: if remote, think of your virtual activities & opportunities to engage with students, professors, and other campus staff" THEN "I felt I belonged on my college campus"
        WHEN question = "My college is culturally competentHelp Note: I felt that the adults on campus helping me with academics, financial, and career counseling understood my values." THEN "My college is culturally competent"
        WHEN question = "My parent(s) were involved and supportive during my transition to collegeHelp Note: If your main caregiver/guardian(s) was another adult (Grandparent(s), Aunt/Uncle, Legal Guardian, etc.), please answer this question with them in mind." THEN "My parent(s) were involved and supportive during my transition to college"
        WHEN question = "I knew who to contact at College Track to get advice or helpHelp Note: For example help accessing your bank book money or talking about your experiences as a new college student." THEN "I knew who to contact at College Track to get advice or help"
        WHEN question = "I understood what academic supports would be available to me on campus (or online on college website if remote) Help note: tutoring, writing center, math help, study groups, office hours, etc." THEN "I understood what academic supports would be available to me on campus (or online on college website if remote)"
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
        WHEN answer = 'ExtremelyHelpful' THEN 'Extremely Helpful'
        WHEN answer = 'VeryHelpful' THEN 'Very Helpful'
        WHEN answer = 'SlightlyHelpful' THEN 'Slightly Helpful'
        WHEN answer = 'ModeratelyHelpful' THEN 'Moderately Helpful'
        WHEN answer = 'NotHelpful' THEN 'Not Helpful'
        Else answer
    END AS answer,