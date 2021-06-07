SELECT workshop_display_name_c, dosage_types_c,Workshop_Global_Academic_Semester_c, dosage_split
FROM `data-studio-260217.attendance_dashboard.attendance_filtered_data`
WHERE workshop_display_name_c LIKE '%Summer Bridge%'