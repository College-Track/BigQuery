CREATE TEMP TABLE region_sites_classification
(
  `function` STRING,
  site_or_region STRING
);

INSERT INTO region_sites_classification
VALUES 
('Mature Site Staff', 'Aurora'),
('Mature Site Staff', 'Denver'),
('Mature Site Staff', 'Boyle Heights'),
('Mature Site Staff', 'East Palo Alto'),
('Mature Site Staff', 'New Orleans'),
('Mature Site Staff', 'Sacramento'),
('Mature Site Staff', 'San Francisco'),
('Mature Site Staff', 'Watts'),
('Mature Site Staff', 'Oakland'),
('Non-Mature Site Staff', 'Crenshaw'),
('Non-Mature Site Staff', 'The Durant Center'),
('Non-Mature Site Staff', 'Ward 8'),
('Non-Mature Region Staff', 'DC'),
('Mature Region Staff', 'LA'),
('Mature Region Staff', 'NOLA'),
('Mature Region Staff', 'Bay Area'),
('Mature Region Staff', 'Sacramento')


 ;


SELECT R.*, RSC.site_or_region
FROM `data-studio-260217.performance_mgt.role_kpi_selection` R
LEFT JOIN region_sites_classification RSC ON RSC.function = R.function