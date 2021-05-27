CREATE TEMP TABLE mature_region_sites
(
  `function` STRING,
  site_or_region STRING
);

INSERT INTO mature_region_sites
VALUES 
('Mature Site Staff', 'Aurora'),
('Mature Site Staff', 'Denver'),
('Mature Site Staff', 'Boyle Heights'),
('Mature Site Staff', 'East Palo Alto'),
('Mature Site Staff', 'New Orleans'),
('Mature Site Staff', 'Sacramento'),
('Mature Site Staff', 'San Francisco'),
('Mature Site Staff', 'Watts'),
('Non-Mature Site Staff', 'Crenshaw'),
('Non-Mature Site Staff', 'The Durant Center'),
('Non-Mature Site Staff', 'Ward 8'),
('Non-Mature Region Staff', 'DC'),
('Mature Region Staff', 'LA'),
('Mature Region Staff', 'NOLA'),
('Mature Region Staff', 'Bay Area'),
('Mature Region Staff', 'Sacramento')


 ;


SELECT *
FROM mature_region_sites;