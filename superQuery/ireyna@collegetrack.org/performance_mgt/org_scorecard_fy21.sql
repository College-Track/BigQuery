ALTER TABLE `org-scorecard-286421.aggregate_data.org_scorecard_program_fy21`
    ADD COLUMN fiscal_year STRING;
UPDATE `org-scorecard-286421.aggregate_data.org_scorecard_program_fy21` --Populate 'fiscal year' with 'FY20'
    SET fiscal_year = "FY21"
    WHERE fiscal_year IS NULL
        ;