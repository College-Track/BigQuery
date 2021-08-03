WITH gather_data AS (
  SELECT
    region_abrev,
    site_abrev,
    site_short,
    site_sort,
    high_school_graduating_class_c,
    GAS_Name,
    AY_Name,
    AT_Cumulative_GPA_bucket,
    sort_AT_Cumulative_GPA,
    ninth_cum_gpa_bucket,
    sort_ninth_cum_gpa_bucket,
        Most_Recent_GPA_Cumulative_bucket,
    sort_Most_Recent_GPA_Cumulative_bucket,
    year_over_year_cum_gpa_bucket,
    sort_year_over_year_cum_gpa_bucket,
    COUNT(Contact_Id) AS student_count,
    SUM(above_325_gpa) AS above_325_gpa,
    SUM(below_275_gpa) AS below_275_gpa,
    AVG(prev_prev_prev_at_cum_gpa) as avg_prev_year_cum_gpa,
    AVG(AT_Cumulative_GPA) AS avg_cum_gpa
    
  FROM
    `data-studio-260217.gpa_dashboard.filtered_gpa_data`
  WHERE GAS_Name = 'Spring 2020-21' -- Has to be manually adjusted each new complete term
  AND student_audit_status_c IN ('Current CT HS Student', 'Leave of Absence', 'Onboarding')
  GROUP BY
    region_abrev,
    site_abrev,
    site_short,
    site_sort,
    high_school_graduating_class_c,
    GAS_Name,
    AY_Name,
    AT_Cumulative_GPA_bucket,
    sort_AT_Cumulative_GPA,
    ninth_cum_gpa_bucket,
    sort_ninth_cum_gpa_bucket,
            Most_Recent_GPA_Cumulative_bucket,
    sort_Most_Recent_GPA_Cumulative_bucket,
    year_over_year_cum_gpa_bucket,
    sort_year_over_year_cum_gpa_bucket
)
SELECT
  GD.*
  
FROM
  gather_data GD