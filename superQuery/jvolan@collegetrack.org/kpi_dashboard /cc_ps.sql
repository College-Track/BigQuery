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

WITH get_on_track_data AS
(

    SELECT 
    Contact_Id,
    indicator_graduated_or_on_track_at_c,
    end_date_c, 
    site_short,
    region
    
    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    WHERE indicator_completed_ct_hs_program_c = true
    AND record_type_id = '01246000000RNnHAAW'
    AND cumulative_credits_awarded_max_calc_c >0
    AND previous_as_c = true
    OR prev_prev_as_c = true
),

 
on_track AS

    SELECT
    contact_Id,
    Max(indicator_graduated_or_on_track_at_c)
    
    FROM get_on_track_data
    GROUP BY