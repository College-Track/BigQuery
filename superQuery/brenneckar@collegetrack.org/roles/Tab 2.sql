SELECT *,
CASE
      WHEN Site LIKE '%Denver%' THEN 'DEN'
      WHEN Site LIKE '%Aurora%' THEN 'AUR'
      WHEN Site LIKE '%San Francisco%' THEN 'SF'
      WHEN Site LIKE '%East Palo Alto%' THEN 'EPA'
      WHEN Site LIKE '%Sacramento%' THEN 'SAC'
      WHEN Site LIKE '%Oakland%' THEN 'OAK'
      WHEN Site LIKE '%Watts%' THEN 'WATTS'
      WHEN Site LIKE '%Boyle Heights%' THEN 'BH'
      WHEN Site LIKE '%Ward 8%' THEN 'WARD 8'
      WHEN Site LIKE '%Durrant%' THEN 'PGC'
      WHEN Site LIKE '%New Orleans%' THEN 'NOLA'
      WHEN Site LIKE '%Crenshaw%' THEN 'CREN'
      ELSE Site
    END site_abrev,
    CASE
      WHEN Site LIKE '%Denver%' THEN 'Denver'
      WHEN Site LIKE '%Aurora%' THEN 'Aurora'
      WHEN Site LIKE '%San Francisco%' THEN 'San Francisco'
      WHEN Site LIKE '%East Palo Alto%' THEN 'East Palo Alto'
      WHEN Site LIKE '%Sacramento%' THEN 'Sacramento'
      WHEN Site LIKE '%Oakland%' THEN 'Oakland'
      WHEN Site LIKE '%Watts%' THEN 'Watts'
      WHEN Site LIKE '%Boyle Heights%' THEN 'Boyle Heights'
      WHEN Site LIKE '%Ward 8%' THEN 'Ward 8'
      WHEN Site LIKE '%Durrant%' THEN 'The Durant Center'
      WHEN Site LIKE '%New Orleans%' THEN 'New Orleans'
      WHEN Site LIKE '%Crenshaw%' THEN 'Crenshaw'
      ELSE Site
    END site_short,
FROM `data-warehouse-289815.roles.role_table`