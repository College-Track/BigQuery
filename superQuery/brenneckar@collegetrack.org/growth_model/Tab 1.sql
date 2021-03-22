WITH gather_data AS (
  SELECT
    region_short,
    site_short,
    Contact_Id,
    CAST(graduated_4_year_degree_4_years_c AS int64) AS graduated_4_year_degree_4_years_c,
    CAST(graduated_4_year_degree_5_years_c AS int64) AS graduated_4_year_degree_5_years_c,
    CAST(graduated_4_year_degree_6_years_c AS int64) AS graduated_4_year_degree_6_years_c,
    CAST(graduated_4_year_degree_c AS int64) AS graduated_4_year_degree_c,
    
  FROM
    `data-warehouse-289815.salesforce_clean.contact_template` C
  WHERE
    years_since_hs_grad_c >= 6
    and indicator_completed_ct_hs_program_c = true
)
SELECT
  region_short,
  site_short,
  COUNT(Contact_Id) AS student_count,
  SUM(graduated_4_year_degree_4_years_c) AS graduated_4_year_degree_4_years_c,
  SUM(graduated_4_year_degree_5_years_c) AS graduated_4_year_degree_5_years_c,
  SUM(graduated_4_year_degree_6_years_c) AS graduated_4_year_degree_6_years_c,
  SUM(graduated_4_year_degree_c) AS graduated_4_year_degree_c
FROM
  gather_data
GROUP BY
  region_short,
  site_short