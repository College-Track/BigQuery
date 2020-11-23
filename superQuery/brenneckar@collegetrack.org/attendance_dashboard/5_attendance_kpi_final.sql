SELECT site, site_abrev, Academic_Term, Region,
SUM (CASE WHEN Indicator_Sem_Attendance_Above_80_c = True THEN 1 ELSE 0 END) as Above_80,
SUM (CASE WHEN Indicator_Sem_Attendance_Below_65_c = True THEN 1 ELSE 0 END) as Below_65,
COUNT(*) as count
FROM `data-studio-260217.attendance_dashboard.kpi_prep`
GROUP BY site, site_abrev, Academic_Term, Region