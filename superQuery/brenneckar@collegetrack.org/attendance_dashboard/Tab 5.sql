SELECT site_short, COUNT(DISTINCT(Contact_Id))
FROM `data-studio-260217.attendance_dashboard.kpi_prep`
WHERE Workshop_Global_Academic_Semester_c = 'Fall 2020-21'
GROUP BY site_short