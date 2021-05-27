CREATE TEMP TABLE mature_region_sites
(
  `function` INT64,
  site_or_region STRING
);

INSERT INTO mature_region_sites
VALUES ('Mature Site Staff', 'Aurora');


SELECT *
FROM mature_region_sites;