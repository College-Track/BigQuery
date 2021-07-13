 SELECT
    contact_Id,
    Gender_c,
    Ethnic_background_c,
    site_short,
    CASE
        WHEN
        (indicator_completed_ct_hs_program_c = true
        AND college_track_status_c = '15A'
        AND most_recent_valid_cumulative_gpa >= 2.5) THEN 1
        ELSE 0
    END AS cc_ps_gpa_2_5_num,

    FROM `data-warehouse-289815.salesforce_clean.contact_template`
--needed widest reporting group to ensure I had all students I need to evaluate if they were in one of my custom denoms. Added in more detail filter logic into case statements above.
    WHERE indicator_completed_ct_hs_program_c = true