SELECT
    ct.student_c,
    attendance_numerator_c AS attended_wellness_sessions,
    site_short
FROM `data-warehouse-289815.salesforce_clean.class_template` CT
LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_at_template` CAT ON CAT.AT_Id = CT.Academic_Semester_c