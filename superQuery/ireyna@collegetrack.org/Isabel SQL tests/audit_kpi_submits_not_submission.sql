/*
CREATE OR REPLACE TABLE 'data-studio-260217.performance_mgt.fy22_audit_kpi_targets_no_submissions'
OPTIONS
    (
    description= "This table pulls in targets not submitted by staff"
    )
AS
*/ 

--SELECT *
--FROM `data-warehouse-289815.google_sheets.team_kpi_target`
WITH gather_all_kpis AS (
SELECT function, role, kpis_by_role
FROM `data-studio-260217.performance_mgt.role_kpi_selection`
ORDER BY function, role
),

gather_unique_function_role AS (
SELECT DISTINCT function function, role 
FROM gather_all_kpis
), 

create_list_of_unseleted_kpis_by_role AS (
SELECT GAFR.function, GAFR.role, GAK.kpis_by_role
FROM gather_unique_function_role GAFR
LEFT JOIN gather_all_kpis GAK ON GAK.role = GAFR.role
--WHERE GAFR.role != GAK.role

/*
create_list_of_unseleted_kpis_by_function AS (
SELECT GAFR.function, GAFR.role, GAK.kpis_by_role
FROM gather_unique_function_role GAFR
LEFT JOIN gather_all_kpis GAK ON GAK.function = GAFR.function
WHERE GAFR.role != GAK.role
*/
)

SELECT DISTINCT CLUK.function, CLUK.role, CLUK.kpis_by_role
FROM create_list_of_unseleted_kpis_by_role CLUK
LEFT JOIN gather_all_kpis GAK ON GAK.role = CLUK.role AND GAK.kpis_by_role = CLUK.kpis_by_role 
WHERE GAK.kpis_by_role IS NULL