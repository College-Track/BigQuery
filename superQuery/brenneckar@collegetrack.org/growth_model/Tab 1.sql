WITH gather_data AS (
  SELECT
    region_short,
    site_short,
    Contact_Id,
    graduated_4_year_degree_4_years_c,
    graduated_4_year_degree_5_years_c,
    graduated_4_year_degree_6_years_c,
    graduated_4_year_degree_c
   
  FROM
    `data-warehouse-289815.salesforce_clean.contact_template` C
    
  WHERE
  years_since_hs_grad_c >= 6
  )
  
  SELECT *
  FROM gather_data