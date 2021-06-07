SELECT
  grade_c, COUNT(*)
FROM
  `data-warehouse-289815.salesforce_clean.contact_template`
  WHERE site_short IN ('Watts', 'Sacramento', 'Denver')