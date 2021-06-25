    SELECT
    site_short,
    SUM(CASE
        WHEN
        (indicator_completed_ct_hs_program_c = true
        AND
        ps_internships_c > 0
        AND
        (anticipated_date_of_graduation_ay_c = 'AY 2021-22'
         AND college_track_status_c = '15A'
         AND Credit_Accumulation_Pace_c NOT IN ("6+ Years", 'Credit Data Missing')
         AND Current_Enrollment_Status_c = "Full-time"
         AND Current_School_Type_c_degree = "Predominantly bachelor's-degree granting")) THEN 1
        ELSE 0
    END) AS fy22_oak_cc_ps_grad_internship_num,
--denominator
    SUM(CASE
        WHEN
        (indicator_completed_ct_hs_program_c = true
        AND
        (anticipated_date_of_graduation_ay_c = 'AY 2021-22'
         AND college_track_status_c = '15A'
         AND Credit_Accumulation_Pace_c NOT IN ("6+ Years", 'Credit Data Missing')
         AND Current_Enrollment_Status_c = "Full-time"
         AND Current_School_Type_c_degree = "Predominantly bachelor's-degree granting")) THEN 1
        ELSE 0
    END) AS fy22_oak_cc_ps_grad_internship_denom,

    FROM `data-warehouse-289815.salesforce_clean.contact_template`
    WHERE indicator_completed_ct_hs_program_c = true
    AND site_short = 'Oakland'
    GROUP BY site_short