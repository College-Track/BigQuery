SELECT
    ddt.site_short,
    ddt.region_short,
    CASE
        WHEN DDT.AY_student_served = 'High School' THEN 1
        ELSE 0
        END AS high_school_student_count,
    CASE
        WHEN DDT.above_80_attendance_fall = 'True' AND DDT.above_80_attendance_spring = 'True'
        THEN 1
        ELSE
            0
        END
            above_80_attendance_memo,
        
        CASE
        WHEN DDT.above_80_attendance_ay = 'True'  THEN 1
        ELSE
            0
        END
            above_80_attendance,

FROM `data-studio-260217.ddt.ay_summary_table` DDT
    LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_template` C
    ON DDT.Contact_Id = C.Contact_Id
WHERE DDT.AY_student_served = 'High School'