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
    END AS indicator_loans_less_30k_loans,
    CASE
        WHEN Overall_Rubric_Color = 'Green' THEN 1
        ELSE 0
    END AS indicator_well_balanced,
    CASE
        WHEN advising_rubric_career_readiness_v_2_c = 'Green'
        AND 
        (academic_networking_50_cred_c = 'Green'
        OR academic_networking_over_50_credits_c = 'Green') THEN 1
        ELSE 0
    END AS indicator_tech_interpersonal_skills
    
    
    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    WHERE current_as_c = true
    AND college_track_status_c = '15A'
),

--annual persistence tight CT defintion
get_persist_at_data AS
(
  SELECT
    contact_id AS persist_contact_id,
    MAX(CASE
        WHEN
        (enrolled_in_any_college_c = true
        AND college_track_status_c = '15A'
        AND AY_Name = 'AY 2020-21'
        AND term_c = 'Fall') THEN 1
        ELSE 0
    END) AS include_in_reporting_group,
    COUNT(AT_Id) AS at_count,
    SUM(indicator_persisted_at_c) AS persist_count
    
    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    WHERE start_date_c < CURRENT_DATE()
        AND((AY_Name = 'AY 2020-21'
        AND term_c <> 'Summer')
        OR
        (AY_Name = 'AY 2021-22'
        AND term_c = 'Fall'))
    GROUP BY contact_id
),

persist_calc AS
(
    SELECT
    persist_contact_id,
    MAX(include_in_reporting_group) AS cc_persist_denom,
    MAX(
    CASE
        WHEN at_count = persist_count THEN 1
        ELSE 0
    END) AS indicator_persisted
    FROM get_persist_at_data
    WHERE include_in_reporting_group = 1
    GROUP BY persist_contact_id
),

join_data AS
(
    SELECT
    get_contact_data.*,
    get_at_data.indicator_fafsa_complete,
    get_at_data.indicator_loans_less_30k_loans,
    get_at_data.indicator_well_balanced,
    get_at_data.indicator_tech_interpersonal_skills,
    persist_calc.indicator_persisted,
    persist_calc.cc_persist_denom

    
    FROM get_contact_data
    LEFT JOIN get_at_data ON at_contact_id = contact_id
    LEFT JOIN persist_calc ON persist_calc.persist_contact_id = contact_id
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
    sum(indicator_well_balanced) AS cc_ps_well_balanced_lifestyle,
    sum(indicator_tech_interpersonal_skills) AS cc_ps_tech_interpersonal_skills,
    sum(indicator_persisted) AS cc_ps_persist_num,
    sum(cc_persist_denom) AS cc_persist_denom,
    
    FROM join_data
    GROUP BY site_short

)

    SELECT
    *
    FROM 
    cc_ps
    
