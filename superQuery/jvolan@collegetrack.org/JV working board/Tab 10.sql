SELECT
    Class_c,
    dosage_types_c,
    global_academic_semester_c
    
    FROM `data-warehouse-289815.salesforce_clean.class_template`
    WHERE global_academic_semester_c = 'a3646000000dMXuAAM'
    GROUP BY Class_c, dosage_types_c, global_academic_semester_c