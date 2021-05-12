get_fy20_alumni_survey_data AS
(
    SELECT
    Contact_Id AS alum_contact_id,
--% of graduates with meaningful employment
    CASE    
        WHEN i_feel_my_current_job_is_meaningful IN ('Strongly Agree', "Agree") THEN 1
        WHEN i_feel_my_current_job_is_meaningful IS NULL THEN NULL
        ELSE 0
    END AS fy20_alumni_survey_meaningful_num,
--denom
    CASE    
        WHEN i_feel_my_current_job_is_meaningful IS NOT NULL THEN 1
        ELSE 0
    END AS fy20_alumni_survey_meaningful_denom,
--
    CASE
        WHEN 
        (indicator_annual_loan_repayment_amount_current_loan_debt_125 / indicator_income_proxy) <=.08 THEN 1
        ELSE 0
    END AS indicator_gainful_employment

    
    FROM `data-warehouse-289815.surveys.fy20_alumni_survey`