WITH gather_data AS (
  SELECT
    region_abrev,
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
prep_data AS (SELECT
  region_abrev,
  COUNT(Contact_Id) AS student_count,
  SUM(graduated_4_year_degree_4_years_c) AS graduated_4_year_degree_4_years_c,
  SUM(graduated_4_year_degree_5_years_c) AS graduated_4_year_degree_5_years_c,
  SUM(graduated_4_year_degree_6_years_c) AS graduated_4_year_degree_6_years_c,
  SUM(graduated_4_year_degree_c) AS graduated_4_year_degree_c
FROM
  gather_data
GROUP BY
  region_abrev
)

SELECT 
region_abrev,
student_count / graduated_4_year_degree_4_years_c AS four_year_rate,
student_count / graduated_4_year_degree_5_years_c AS five_year_rate,
student_count / graduated_4_year_degree_6_years_c AS six_year_rate,
student_count / graduated_4_year_degree_c AS grad_rate_overall,
FROM prep_data