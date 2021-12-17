WITH gather_ATs AS
(
    SELECT
    Contact_Id,
    site,
    indicator_graduated_or_on_track_at_c,
    credits_accumulated_c,
    term_c,
    start_date_c,
    
    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    WHERE AY_Name = "AY 2020-21"
    AND AT_Record_Type_Name = "College/University Semester"
    AND term_c = "Spring"
    OR (term_c = "Summer"
    AND credits_accumulated_c >0)
    AND indicator_completed_ct_hs_program_c = TRUE
    AND high_school_graduating_class_c IN ("2020","2019","2018","2017","2016")
)
    SELECT
    Contact_Id,
    Max(indicator_graduated_or_on_track_at_c) AS on_track_sp_summer_combine,

    FROM gather_ATs
    GROUP BY Contact_Id