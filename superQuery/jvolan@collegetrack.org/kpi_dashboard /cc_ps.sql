/*WITH get_fafsa_data AS    
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
    site_short,
    SUM(projected_6_year_grad) + SUM(alumni_already) AS cc_ps_6_year_grad_num,
    count(Contact_Id) AS cc_ps_6_year_grad_denom,
    SUM(projected_6_year_grad) AS projected_6_year_grad,
    SUM(alumni_already) AS alumni_already,
    
    FROM get_projected_6_year_grad_data
    GROUP BY site_short
),

get_2_yr_transfer_data AS
(
*/

SELECT 
contact_Id,
    Current_school_name,
    school_type,
    current_enrollment_status_c,
    college_first_enrolled_school_c,
    college_first_enrolled_school_type_c,

    FROM `data-warehouse-289815.salesforce_clean.contact_template`
    WHERE Current_School_Type_c_degree IS NOT NULL
    AND Current_School_Type_c_degree NOT LIKE "Not Classified"
    AND college_track_status_c = '15A'

/*
    SELECT  
    contact_Id,
    Current_school_name,
    Current_School_Type_c_degree,
    current_enrollment_status_c,
    college_first_enrolled_school_c,
    college_first_enrolled_school_type_c,
    CASE
        WHEN
        (Current_School_Type_c_degree = '4-Year'
        AND current_enrollment_status_c IN ('Full-time','Part-time')) THEN 1
        ELSE 0
        END AS current_enrolled_4_year
        
    FROM `data-warehouse-289815.salesforce_clean.contact_template`
    WHERE college_first_enrolled_school_type_c IN ("Predominantly associate's-degree granting","Predominantly certificate-degree granting")
*/

        
/*
    SELECT
    site_short,
    cc_ps_6_year_grad_num,
    cc_ps_6_year_grad_denom,
    projected_6_year_grad,
    alumni_already,
    kpi_fafsa_complete.cc_ps_fafsa_complete,
    
    FROM kpi_projected_6_year_grad
    LEFT JOIN kpi_fafsa_complete ON kpi_fafsa_complete.fafsa_site = site_short
*/