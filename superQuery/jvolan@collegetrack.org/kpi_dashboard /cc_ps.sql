WITH get_contact_data AS
(
    SELECT
    contact_Id,
    site_short,
    
    -- 6 year projected numerator, done as still PS & alumni already so we can further split out numerator if needed)
    CASE
      WHEN
        grade_c = 'Year 6'
        AND indicator_completed_ct_hs_program_c = true
        AND
        ((Credit_Accumulation_Pace_c != "6+ Years"
        AND Current_Enrollment_Status_c = "Full-time"
        AND college_track_status_c = '15A')
        OR
        college_track_status_c = '17A') THEN 1
        ELSE 0
        END AS cc_ps_projected_grad_num,

    --6 year projected grad denominator
    CASE
        WHEN
        (grade_c = 'Year 6'
        AND indicator_completed_ct_hs_program_c = true) THEN 1
        ELSE 0
    END AS cc_ps_projected_grad_denom,
    
    --2-year transfer num & denom
    CASE    
        WHEN
        (indicator_completed_ct_hs_program_c = true
        AND college_track_status_c = '15A'
        AND grade_c = 'Year 2'
        AND school_type = '4-Year'
        AND current_enrollment_status_c IN ("Full-time","Part-time")
        AND college_first_enrolled_school_type_c IN ("Predominantly associate's-degree granting","Predominantly certificate-degree granting")) THEN 1
        ELSE 0
        END AS x_2_yr_transfer_num,
    CASE
        WHEN
        (indicator_completed_ct_hs_program_c = true
        AND grade_c = 'Year 2'
        AND college_first_enrolled_school_type_c IN ("Predominantly associate's-degree granting","Predominantly certificate-degree granting")) THEN 1
        ELSE 0
        END AS x_2_yr_transfer_denom,
        
    --% of grads who did internship num & denom
    CASE
        WHEN
        (indicator_completed_ct_hs_program_c = true
        AND 
        ps_internships_c > 0
        AND
        (anticipated_date_of_graduation_ay_c = 'AY 2020-21'
        OR
        academic_year_4_year_degree_earned_c = 'AY 2020-21')) THEN 1
        ELSE 0
    END AS cc_ps_grad_internship_num,
    CASE
        WHEN
        (indicator_completed_ct_hs_program_c = true
        AND 
        (anticipated_date_of_graduation_ay_c = 'AY 2020-21'
        OR
        academic_year_4_year_degree_earned_c = 'AY 2020-21')) THEN 1
        ELSE 0
    END AS cc_ps_grad_internship_denom,
    
    --most recent CGPA
    CASE
        WHEN
        (indicator_completed_ct_hs_program_c = true
        AND college_track_status_c = '15A'
        AND Most_Recent_GPA_Cumulative_c >= 2.5) THEN 1
        ELSE 0
    END AS cc_ps_gpa_2_5_num,

    FROM `data-warehouse-289815.salesforce_clean.contact_template`
    WHERE 
    (college_track_status_c IN ('11A','12A')
    AND grade_c = "12th Grade")
    OR indicator_completed_ct_hs_program_c = true
),

-- data from ATs
--fafsa completion
get_at_data AS
(
    SELECT
    AT_Id,
    Contact_Id AS at_contact_id,
    site_short AS at_site,
    CASE    
        WHEN filing_status_c = 'FS_G' THEN 1
        ELSE 0
    END AS indicator_fafsa_complete,
    CASE
        WHEN 
        loans_c IN ('LN_G','LN_Y') THEN 1
        ELSE 0
    END AS indicator_loans_less_30k_loans
    
    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    WHERE current_as_c = true
    AND college_track_status_c = '15A'
),
    
/*
persist_at_reporting_group AS
(
    SELECT
    count(Contact_Id) AS reporting_group,
    
    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    WHERE
    (AT_Enrollment_Status_c IN ('Full-time','Part-time')
        AND AY_Name = 'AY 2020-21'
        AND term_c = 'Fall'
        AND AT_school_type IN ('2-year', '4-year'))
    GROUP BY contact_Id
)

    SELECT
    contact_id,
    count(AT_id) AS persist_denom,
    sum(indicator_persisted_at_c) AS persist_num,
    max(persist_at_reporting_group.reporting_group) AS in_reporting_group,
    
    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    LEFT JOIN persist_at_reporting_group ON persist_at_reporting_group.reporting_group = contact_id

    WHERE AY_Name = 'AY 2020-21'
    AND term_c != 'Summer'
    GROUP BY Contact_Id
*/

join_data AS
(
    SELECT
    get_contact_data.*,
    get_at_data.indicator_fafsa_complete,
    get_at_data.indicator_loans_less_30k_loans,
    
    FROM get_contact_data
    LEFT JOIN get_at_data ON at_contact_id = contact_id
),
    

cc_ps AS
(
    SELECT
    site_short,
    sum(cc_ps_projected_grad_num) AS cc_ps_projected_grad_num,
    sum(cc_ps_projected_grad_denom) AS cc_ps_projected_grad_denom,
    sum(x_2_yr_transfer_num) AS cc_ps_2_yr_transfer_num,
    sum(x_2_yr_transfer_denom) AS cc_ps_2_yr_transfer_denom,
    sum(cc_ps_grad_internship_num) AS cc_ps_grad_internship_num,
    sum(cc_ps_grad_internship_denom) AS cc_ps_grad_internship_denom,
    sum(cc_ps_gpa_2_5_num) AS cc_ps_gpa_2_5_num,
    sum(indicator_loans_less_30k_loans) AS cc_ps_loans_30k,
    sum(indicator_fafsa_complete) AS cc_ps_fasfa_complete,
    
    FROM join_data
    GROUP BY site_short

)

    SELECT
    *
    FROM 
    cc_ps
    

--original starting queries for ref only, combined above
/*
WITH get_fafsa_data AS    
(
    SELECT 
    site_short AS fafsa_site,
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
    fafsa_site,
    sum(indicator_fafsa_complete) AS cc_ps_fafsa_complete,
    
    FROM get_fafsa_data
    GROUP BY fafsa_site
),

get_projected_6_year_grad_data AS
(
    SELECT
    Contact_Id,
    site_short,
    CASE
      WHEN
        (Credit_Accumulation_Pace_c != "6+ Years"
        AND Current_Enrollment_Status_c = "Full-time"
        AND college_track_status_c = '15A') THEN 1
        ELSE 0
    END AS projected_6_year_grad,
    CASE
        WHEN college_track_status_c = '17A' THEN 1
        ELSE 0
    END AS alumni_already
        

    FROM `data-warehouse-289815.salesforce_clean.contact_template`
    WHERE grade_c = 'Year 6'
    AND indicator_completed_ct_hs_program_c = true
),

kpi_projected_6_year_grad AS
(
    SELECT
    site_short AS site_6_yr_grad,
    SUM(projected_6_year_grad) + SUM(alumni_already) AS cc_ps_6_year_grad_num,
    count(Contact_Id) AS cc_ps_6_year_grad_denom,
    SUM(projected_6_year_grad) AS projected_6_year_grad,
    SUM(alumni_already) AS alumni_already,
    
    FROM get_projected_6_year_grad_data
    GROUP BY site_short
),

get_2_yr_transfer_data AS
(
    SELECT 
    contact_Id,
    site_short AS site_2_yr,
    CASE    
        WHEN
        school_type = '4-Year'
        AND current_enrollment_status_c IN ("Full-time","Part-time") THEN 1
        ELSE 0
        END AS currently_enrolled_4_year,
    Current_school_name,
    Current_School_Type_c_degree,
    current_enrollment_status_c,
    college_first_enrolled_school_c,
    college_first_enrolled_school_type_c,

    FROM `data-warehouse-289815.salesforce_clean.contact_template`
    WHERE indicator_completed_ct_hs_program_c = true
    AND grade_c = 'Year 2'
    AND college_first_enrolled_school_type_c IN ("Predominantly associate's-degree granting","Predominantly certificate-degree granting")
),

kpi_2_yr_transfer AS
(
    SELECT  
    site_2_yr,
    sum(currently_enrolled_4_year) AS cc_ps_2_yr_transfer_num,
    count(contact_Id) AS cc_ps_2_yr_transfer_denom,

    FROM get_2_yr_transfer_data
    GROUP BY site_2_yr
)
        
    SELECT
    site_short,
    max(kpi_projected_6_year_grad.cc_ps_6_year_grad_num) AS cc_ps_6_year_grad_num,
    max(kpi_projected_6_year_grad.cc_ps_6_year_grad_denom) AS cc_ps_6_year_grad_denom,
    max(kpi_fafsa_complete.cc_ps_fafsa_complete) AS cc_ps_fafsa_complete,
    max(kpi_2_yr_transfer.cc_ps_2_yr_transfer_num) AS cc_ps_2_yr_transfer_num,
    max(kpi_2_yr_transfer.cc_ps_2_yr_transfer_denom) AS cc_ps_2_yr_transfer_denom,
    
    FROM `data-warehouse-289815.salesforce_clean.contact_template`
    LEFT JOIN kpi_projected_6_year_grad ON kpi_projected_6_year_grad.site_6_yr_grad = site_short
    LEFT JOIN kpi_fafsa_complete ON kpi_fafsa_complete.fafsa_site = site_short
    LEFT JOIN kpi_2_yr_transfer ON kpi_2_yr_transfer.site_2_yr = site_short
    GROUP BY site_short
*/