SELECT attendance_numerator_c, attendance_denominator_c, date_c, workshop_display_name_c
FROM `data-studio-260217.attendance_dashboard.attendance_filtered_data`
WHERE Academic_Semester_c ='a1a460000019uAjAAI' AND attendance_denominator_c > 0