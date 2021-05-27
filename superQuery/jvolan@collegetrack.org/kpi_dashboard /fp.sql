WITH gather_survey_data AS
(
    SELECT
    site_short AS survey_site_short,
    contact_id AS ps_survey_scholarship_denom,
    CASE
        WHEN i_am_able_to_receive_my_scholarship_funds_from_college_track IN ('StronglyAgree', 'Strongly Agree', 'Agree') THEN 1
        ELSE 0
    END AS ps_survey_scholarship_num
    
    FROM  `data-studio-260217.surveys.fy21_ps_survey_wide_prepped`
    WHERE i_am_able_to_receive_my_scholarship_funds_from_college_track IS NOT NULL
),

gather_contact_data AS
(
    SELECT
    site_short,
    SUM(
    CASE
        WHEN fa_req_fafsa_c = 'Submitted' THEN 1
        ELSE 0
    END) AS fp_12_fafsa_complete_num
    FROM `data-warehouse-289815.salesforce_clean.contact_template`
    GROUP BY site_short
)

    SELECT
    gather_contact_data.*,
    gather_survey_data.ps_survey_scholarship_denom,
    gather_survey_data.ps_survey_scholarship_num,
     
    FROM gather_contact_data
    LEFT JOIN gather_survey_data ON gather_survey_data.survey_site_short = site_short


