SELECT P.*,
C.region_abrev
FROM `data-studio-260217.performance_mgt.fy22_projections` P
LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_template` C ON C.site_short = P.site_short