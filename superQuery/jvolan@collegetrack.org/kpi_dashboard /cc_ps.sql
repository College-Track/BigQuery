/*WITH get_fafsa_data AS    
(
    SELECT 
    Contact_Id,
    site_short,
    CASE
        WHEN fa_req_fafsa_c = 'Submitted' then 1
        Else 0  
    End AS indicator_fafsa_complete
    
    FROM `data-warehouse-289815.salesforce_clean.contact_template`
    WHERE college_track_status_c IN ('11A','12A')
    AND grade_c = "12th Grade"
),

kpi_fafsa_complete AS
(
    SELECT
    site_short,
    SUM(indicator_fafsa_complete) AS cc_ps_fafsa_complete,
    FROM get_fafsa_data
    Group BY site_short
),

get_projected_6_year_grad_data AS
(
*/
    SELECT
    count(Contact_Id),
    site_short,

    FROM `data-warehouse-289815.salesforce_clean.contact_template`
    WHERE indicator_years_since_hs_graduation_c <6
    AND indicator_years_since_hs_graduation_c > 5
    GROUP BY site_short

/*
    SELECT
    count(Contact_Id) AS cc_ps_6_year_grad_num,
    SUM(projected_6_year_grad) AS cc_ps_6_year_grad_denom,
    site_short
    FROM get_projected_6_year_grad_data
    GROUP BY site_short
    
*/

