WITH get_student_grade AS
(
    SELECT
    Contact_Id,
    AT_Id,
    AT_Grade_c,
    global_academic_semester_c,
    
    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    WHERE global_academic_semester_c = 'a3646000000dMXuAAM'
    AND college_track_status_c = '11A'
    GROUP BY Contact_Id, AT_Id, AT_Grade_c, global_academic_semester_c
),

get_enrollments AS
(
    SELECT
    Class_c AS e_class,
    academic_semester_c,
    get_student_grade.AT_Grade_c,
    get_student_grade.global_academic_semester_c AS w_gas

    FROM `data-warehouse-289815.salesforce.class_registration_c`
    LEFT JOIN get_student_grade ON AT_Id = academic_semester_c
    WHERE status_c = "Enrolled"
)
    SELECT
    * ,
    c.dosage_types_c,
    
    FROM get_enrollments
    LEFT JOIN `data-warehouse-289815.salesforce_clean.class_template`c ON Class_c = e_class
    WHERE global_academic_semester_c = "a3646000000dMXuAAM"