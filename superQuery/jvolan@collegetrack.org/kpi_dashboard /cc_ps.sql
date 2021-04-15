WITH get_fafsa_data AS    
(
    SELECT 
    Contact_Id,
    site_short,
    region_short,
    CASE
        WHEN fa_req_fafsa_c = 'Submitted' then 1
        Else 0  
    End AS indicator_fafsa_complete
    
    FROM `data-warehouse-289815.salesforce_clean.contact_template`
    WHERE college_track_status_c IN ('11A','12A')
    AND grade_c = "12th Grade"
)


    SELECT 
    SUM(indicator_fafsa_complete) AS cc_ps_fafsa_complete
    FROM get_fafsa_data
    Group BY site_short, region_short
    
/*WITH get_contact_data AS
(
    SELECT
    Contact_Id,
    site_short,
    high_school_graduating_class_c,
    current_school_name,
    current_school_type_c_degree,
    current_enrollment_status_c,
    indicator_years_since_hs_graduation_c,
    graduated_4_year_degree_c,
    graduated_4_year_degree_4_years_c,
    graduated_4_year_degree_5_years_c,
    graduated_4_year_degree_6_years_c,
    current_cc_advisor_2_c,
    
    FROM `data-warehouse-289815.salesforce_clean.contact_template`
    WHERE indicator_completed_ct_hs_program_c = true
),
*/

/*
    SELECT 
    Contact_Id,
    indicator_graduated_or_on_track_at_c,
    max(end_date_c), 
    site_short,
    region
    
    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    WHERE indicator_completed_ct_hs_program_c = true
    AND record_type_id = '01246000000RNnHAAW'
    AND cumulative_credits_awarded_max_calc_c >0
    AND previous_as_c = true
    OR prev_prev_as_c = true

/*
 
on_track AS

    SELECT
    contact_Id,
    Max(indicator_graduated_or_on_track_at_c)
    
    FROM get_on_track_data
    GROUP BY
    
    
    */