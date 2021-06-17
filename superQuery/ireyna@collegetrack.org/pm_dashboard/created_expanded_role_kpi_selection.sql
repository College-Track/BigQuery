SELECT R.*, RSC.site_or_region
FROM `data-studio-260217.performance_mgt.role_kpi_selection` R
LEFT JOIN region_sites_classification RSC ON RSC.function = R.function