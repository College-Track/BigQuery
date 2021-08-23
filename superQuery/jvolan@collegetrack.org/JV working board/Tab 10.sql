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

get_dosage_type AS
(
    SELECT
    Class_c AS d_class,
    dosage_types_c
    
    FROM `data-warehouse-289815.salesforce_clean.class_template`
),

get_enrollments AS
(
    SELECT
    Class_c AS e_class,
    academic_semester_c,
    get_student_grade.AT_Grade_c,
    get_student_grade.global_academic_semester_c,
    get_dosage_type.dosage_types_c

    FROM `data-warehouse-289815.salesforce.class_registration_c`
    LEFT JOIN get_student_grade ON AT_Id = academic_semester_c
    LEFT JOIN get_dosage_type ON d_class = Class_c
    WHERE status_c = "Enrolled"
)
    SELECT
    * except (academic_semester_c)
    
    FROM get_enrollments
    WHERE global_academic_semester_c = "a3646000000dMXuAAM"
    AND dosage_types_c = "Advisory"
    GROUP BY e_class, AT_Grade_c,global_academic_semester_c, dosage_types_c