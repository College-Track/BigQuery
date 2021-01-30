#Composite readiness for class 2021 in February 2020 (their 12th grade senior year)

WITH student_data AS (
SELECT A_T.contact_id AS contact_id,full_name_c,act_composite_score_c, sat_total_score_c,version_c, status_c, test_date_c, student_audit_status_c AS ct_status_at, term_c, AT_grade_c, 
high_school_class_c, site_short, readiness_composite_off_c, readiness_math_official_c, readiness_english_official_c

FROM `data-warehouse-289815.salesforce_clean.test_clean` AS test
LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_at_template` AS A_T
    ON test.academic_semester_c = A_T.AT_id
    
)

SELECT Contact_Id, full_name_c,act_composite_score_c, sat_total_score_c, readiness_composite_off_c, readiness_math_official_c,readiness_english_official_c,
high_school_class_c, site_short
FROM student_Data as s1
WHERE (sat_total_score_c = 
    (
    select max(sat_total_score_c) AS max_sat
    FROM student_Data as s2
    WHERE s1.contact_id = s2.contact_id
    AND version_c = 'Official'
    AND status_c = 'Completed'
    AND test_date_c <= '2019-02-28'
    AND AT_grade_c = '11th Grade'
    AND high_school_class_c = '2020')
    )

OR 
    (
    act_composite_score_c = 
    (select max(act_composite_score_c) AS max_act 
    FROM student_Data as s2
    WHERE s1.contact_id = s2.contact_id
    AND version_c = 'Official'
AND status_c = 'Completed'
AND test_date_c <= '2019-02-28'
AND AT_grade_c = '11th Grade'
AND high_school_class_c = '2020')
    )
    
    
AND version_c = 'Official'
AND status_c = 'Completed'
AND test_date_c <= '2019-02-28'
AND AT_grade_c = '11th Grade'
AND high_school_class_c = '2020'
AND (Term_c = 'Fall' AND ct_status_at= 'Current CT HS Student')
group by Contact_Id, full_name_c,act_composite_score_c, sat_total_score_c, readiness_composite_off_c, readiness_math_official_c,
readiness_english_official_c,high_school_class_c, site_short