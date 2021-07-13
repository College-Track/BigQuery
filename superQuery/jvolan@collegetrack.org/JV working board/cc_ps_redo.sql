WITH get_contact_data AS
(
    SELECT
    contact_Id,
    site_short,
--% of 2yr students transferring to a 4yr within 3 years
--cohort based, trending is students in year 3. final calc is done in fall of year 4.  Will need to be reworked for final
--denom for trending, currently in year 3 started at 2-year school or lower. Will need to be reworked for final
    CASE
        WHEN
        (indicator_completed_ct_hs_program_c = true
        AND grade_c = 'Year 3'
        AND college_first_enrolled_school_type_c IN ("Predominantly associate's-degree granting","Predominantly certificate-degree granting")) THEN 1
        ELSE 0
        END AS x_2_yr_transfer_denom,
    FROM `data-warehouse-289815.salesforce_clean.contact_template`
--needed widest reporting group to ensure I had all students I need to evaluate if they were in one of my custom denoms. Added in more detail filter logic into case statements above.
    WHERE indicator_completed_ct_hs_program_c = true
),

-- adv rubric data from current AT
--numerators needed only, denom is all active PS students for these
get_at_data AS
(
    SELECT
    AT_Id,
    Contact_Id AS at_contact_id,
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

    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    WHERE college_track_status_c = '15A'
    AND(
    (CURRENT_DATE() < '2021-07-01'
    AND current_as_c = TRUE)
    OR
    (CURRENT_DATE() > '2021-07-01'
    AND previous_as_c = TRUE))
    LIMIT 1
)

 SELECT
    *,
    get_at_data.x_2_yr_transfer_num,

    FROM get_contact_data
    LEFT JOIN get_at_data ON at_contact_id = contact_id 
    WHERE x_2_yr_transfer_denom = 1
