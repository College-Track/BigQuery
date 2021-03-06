WITH workshop_enrollments AS
(
SELECT
    COUNT(class_c) AS workshops_enrolled,
    academic_semester_c,
    FROM `data-warehouse-289815.salesforce.class_registration_c`
    WHERE status_c = 'Enrolled'
    GROUP BY academic_semester_c
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
    workshop_enrollments.academic_semester_c,
    workshop_enrollments.workshops_enrolled,
    
    FROM student_at
    LEFT JOIN workshop_enrollments ON workshop_enrollments.academic_semester_c = AT_Id