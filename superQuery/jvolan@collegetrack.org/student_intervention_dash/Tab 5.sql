WITH workshop_enrollments AS
(
SELECT
    COUNT(Class__c) AS workshops_enrolled,
    Academic_Semester__c,
    FROM `data-warehouse-289815.salesforce_raw.Class_Registration__c`
    WHERE Status__c = 'Enrolled'
    GROUP BY Academic_Semester__c
),

student_at AS
(
SELECT
--basic contact info & demos
    Contact_Id,
    Full_Name_c,
    site_abrev AS Site,
    region_abrev AS region,
    AT_Name,
    AT_Id,
    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    WHERE current_as_c = TRUE
    AND college_track_status_c IN ("11A", "12A")
)

SELECT  
    student_at.*,
    workshop_enrollments.Academic_Semester__c,
    workshop_enrollments.workshops_enrolled,
    
    FROM student_at
    LEFT JOIN workshop_enrollments ON workshop_enrollments.Academic_Semester__c = AT_Id