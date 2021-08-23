WITH get_student_grade AS
(
    SELECT
    Contact_Id,
    AT_Id,
    AT_Grade_c,
    
    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    WHERE global_academic_semester_c = 'a3646000000dMXuAAM'
    AND college_track_status_c = '11A'
    GROUP BY Contact_Id, AT_Id, AT_Grade_c
)
    SELECT
    id,
    Class_c AS e_class,
    get_student_grade.AT_Grade_c AS AT_Grade,

    FROM `data-warehouse-289815.salesforce.class_registration_c`
    LEFT JOIN get_student_grade ON AT_Id = academic_semester_c
    WHERE status_c = "Enrolled"
    GROUP BY id, get_student_grade.AT_Grade_c, Class_c

/*
get_class_dosage_type AS
(
    SELECT
    Class_c,
    dosage_types_c,
    global_academic_semester_c
    
    FROM `data-warehouse-289815.salesforce_clean.class_template`
    WHERE global_academic_semester_c = 'a3646000000dMXuAAM'
    GROUP BY Class_c, dosage_types_c, global_academic_semester_c
)
    
    SELECT 
    e_class,
    AT_Grade,
    get_class_dosage_type.dosage_types_c
    
    FROM enrollments_student_grade
    LEFT JOIN get_class_dosage_type ON Class_c = e_class
    GROUP BY e_class, AT_Grade, get_class_dosage_type.dosage_types_c
*/