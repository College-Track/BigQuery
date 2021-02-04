SELECT outcome_c, count(_)
FROM `data-studio-260217.attendance_dashboard.attendance_filtered_data`
WHERE Workshop_Global_Academic_Semester_c ='Spring 2020-21' 
GROUP BY outcome_c