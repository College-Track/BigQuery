SELECT role, kpis_by_role,
CASE 
        WHEN function = "Mature Site Staff" THEN "Mature_Site_Staff" 
        WHEN function = "Non-Mature Site Staff" THEN "Non-Mature_Site_Sraff"
        ELSE NULL 
        END AS function
FROM `data-studio-260217.performance_mgt.role_kpi_selection` #clean list of KPIs by Role
ORDER BY function, role