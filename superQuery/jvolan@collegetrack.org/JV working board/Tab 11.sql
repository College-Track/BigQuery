    SELECT
    AT_Id,
    Gender_c AS at_gender,
    Ethnic_background_c AS at_ethnic_background,
    Contact_Id AS at_contact_id,
    site_short AS at_site,

    CASE
        WHEN
        (indicator_completed_ct_hs_program_c = true
        AND college_track_status_c = '15A'
        AND grade_c = 'Year 3'
        AND AT_school_type = '4-Year'
        AND AT_Enrollment_Status_c IN ("Full-time","Part-time")
        AND college_first_enrolled_school_type_c IN ("Predominantly associate's-degree granting","Predominantly certificate-degree granting")) THEN 1
        ELSE 0
        END AS x_2_yr_transfer_num,
    --% of students with a 2.5+ cumulative GPA
    --Will need to be reworked for final if we want to ensure we're pulling GPA from uniform point in time
    CASE
        WHEN
        (indicator_completed_ct_hs_program_c = true
        AND college_track_status_c = '15A'
        AND AT_Cumulative_GPA >= 2.5) THEN 1
        ELSE 0
    END AS cc_ps_gpa_2_5_num,

    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    WHERE college_track_status_c = '15A'
    AND(
    (CURRENT_DATE() < '2021-07-01'
    AND current_as_c = TRUE)
    OR
    (CURRENT_DATE() > '2021-07-01'
    AND previous_as_c = TRUE))
