    SELECT
    Contact_Id,
    CASE
        WHEN
        (anticipated_date_of_graduation_ay_c = 'AY 2020-21'
         AND college_track_status_c = '15A'
         AND Credit_Accumulation_Pace_c NOT IN ("6+ Years", 'Credit Data Missing')
         AND credits_accumulated_most_recent_c >= 80
         AND Current_Enrollment_Status_c = "Full-time"
         AND Current_School_Type_c_degree = "Predominantly bachelor's-degree granting") THEN 'projected grad'
         WHEN academic_year_4_year_degree_earned_c = 'AY 2020-21' THEN 'AY alumni'
         ELSE ""
         END AS ps_alum_bucket

    FROM `data-warehouse-289815.salesforce_clean.contact_template`
    WHERE indicator_completed_ct_hs_program_c = true
    AND academic_year_4_year_degree_earned_c = 'AY 2020-21'