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
),
prep_data AS (
  SELECT
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
),
region_rates AS (
  SELECT
    region_abrev,
    graduated_4_year_degree_4_years_c / student_count AS four_year_rate,
    graduated_4_year_degree_5_years_c / student_count AS five_year_rate,
    graduated_4_year_degree_6_years_c / student_count AS six_year_rate,
    graduated_4_year_degree_c / student_count AS grad_rate_overall,
  FROM
    prep_data
),
new_region_rate AS (
  SELECT
    "Other" AS region_abrev,
    SUM(graduated_4_year_degree_4_years_c) / SUM(student_count) AS four_year_rate,
    SUM(graduated_4_year_degree_5_years_c) / SUM(student_count) AS five_year_rate,
    SUM(graduated_4_year_degree_6_years_c) / SUM(student_count) AS six_year_rate,
    SUM(graduated_4_year_degree_c) / SUM(student_count) AS grad_rate_overall
  FROM
    prep_data
),
join_data AS (
  SELECT
    *
  FROM
    new_region_rate
  UNION ALL
    (
      SELECT
        *
      FROM
        region_rates
    )
)
SELECT
  region_abrev,
  four_year_rate,
  (five_year_rate - four_year_rate) AS year_5,
  (six_year_rate - five_year_rate) as year_6,
  (grad_rate_overall - six_year_rate) as overall
FROM
  join_data