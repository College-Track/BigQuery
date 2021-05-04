WITH gather_covi_data AS (
SELECT 
academic_semester_c,
co_vitality_indicator_c,
co_vitality_scorecard_color_c,
version_c,
status_c,
test_date_c, 
id AS test_record_id, #test id
student_site_c,
CASE 
        WHEN id IS NOT NULL THEN 1
        ELSE 0
    END AS covi_assessment_ay

FROM `data-warehouse-289815.salesforce_clean.test_clean` COVI

WHERE record_type_id ='0121M000001cmuDQAQ'
AND status_c = 'Completed'
),

gather_at_data AS
(
SELECT 
at_id,
contact_id,
AY_Name

FROM `data-warehouse-289815.salesforce_clean.contact_at_template` 
WHERE record_type_id = '01246000000RNnSAAW' 
AND site_short != 'College Track Arlen'
AND AY_Name = 'AY 2020-21'
AND College_Track_Status_Name = 'Current CT HS Student'

),

prep_kpi AS (
SELECT 
    covi_assessment_ay,
    student_site_c,
    contact_id
 
FROM gather_at_data as A     
LEFT JOIN gather_covi_data as C ON C.academic_semester_c=A.at_id
group by contact_id, student_site_c,covi_assessment_ay
)

SELECT 
SUM (covi_assessment_ay),
student_site_c
FROM prep_kpi
GROUP BY student_site_c



