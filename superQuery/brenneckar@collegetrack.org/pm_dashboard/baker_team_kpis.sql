SELECT site_short, 
region_abrev,
student_type,
SUM(student_count) AS student_count,

FROM `data-studio-260217.performance_mgt.fy22_projections`
GROUP BY site_short, 
region_abrev,
student_type