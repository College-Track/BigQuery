SELECT workshop_display_name_c, dosage_types_c
FROM `data-studio-260217.attendance_dashboard.attendance_filtered_data`
WHERE REGEXP_CONTAINS(workshop_display_name_c, 'Summer Bridge')