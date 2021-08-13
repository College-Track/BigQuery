SELECT
CASE 
    WHEN kpis_by_role = '% of all students with GPA 3.25+' THEN '% of students with a 3.25+ cumulative HS GPA'
    ELSE kpis_by_role
    END AS kpis_by_role,
student_count,
target_numerator,
count_of_targets,
CASE
    WHEN site_or_region = 'East Palo Alto' THEN 'NOR CAL'
    WHEN site_or_region = 'Oakland' THEN 'NOR CAL'
    WHEN site_or_region = 'San Francisco' THEN 'NOR CAL'
    WHEN site_or_region = 'Sacramento' THEN 'NOR CAL'
    WHEN site_or_region = 'Boyle Heights' THEN 'LA'
    WHEN site_or_region = 'Watts' THEN 'LA'
    WHEN site_or_region = 'Crenshaw' THEN 'LA'
    WHEN site_or_region = 'Aurora' THEN 'CO'
    WHEN site_or_region = 'Denver' THEN 'CO'
    WHEN site_or_region = 'New Orleans' THEN 'NOLA' 
    WHEN site_or_region = 'The Durant Center' THEN 'DC'
    WHEN site_or_region = 'Ward 8' THEN 'DC'
    ELSE site_or_region
END AS site_or_region,


FROM `data-studio-260217.performance_mgt.fy22_team_kpis`  team_kpis
WHERE program = 1

GROUP BY 
kpis_by_role,
site_or_region,
student_count,
target_numerator,
count_of_targets