get_student_grade AS
(
    SELECT
    Contact_Id,
    AT_grade_c,
    
    
    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    WHERE global_academic_semester_c = 'a3646000000dMXuAAM'
    AND college_track_status_c = '11A'
    GROUP BY Contact_Id, AT_Grade_c
),

advisory_grade_check AS
(   
    SELECT
    Class_c,
    workshop_display_name_c AS w_name_check,
    get_student_grade.AT_Grade_c

    FROM `data-warehouse-289815.salesforce_clean.class_template`
    LEFT JOIN get_student_grade ON Contact_Id = Student_c
    WHERE global_academic_semester_c = 'a3646000000dMXuAAM'
    AND dosage_types_c = 'Advisory'
    GROUP BY Class_c, workshop_display_name_c, get_student_grade.AT_Grade_c