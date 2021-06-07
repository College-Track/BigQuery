-- SELECT workshop_display_name_c, dosage_types_c,Workshop_Global_Academic_Semester_c, dosage_split
-- FROM `data-studio-260217.attendance_dashboard.attendance_filtered_data`
-- WHERE  Workshop_Display_Name_c = 'CC: Virtual Regional Summer Bridge CCCT'


SELECT Class_c, Workshop_Display_Name_c
FROM `data-warehouse-289815.salesforce_clean.class_template` 
WHERE Workshop_Display_Name_c = 'CC: Virtual Regional Summer Bridge CCCT'