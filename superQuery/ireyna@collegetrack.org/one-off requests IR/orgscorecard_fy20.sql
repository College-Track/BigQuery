/*
    --Add column to outcomes_overview_fy20 table
    ALTER TABLE `org-scorecard-286421.aggregate_data.outcomes_overview_fy20` 
    ADD COLUMN fiscal_year STRING
*/

     
    CREATE
    OR REPLACE TABLE `org-scorecard-286421.aggregate_data.outcomes_overview_fy20` OPTIONS (
    description = "Org Scorecard FY20 outcomes overview"
)
AS 


--Populating newly created column with "FY20": fiscal_year 
  SELECT * EXCEPT (fiscal_year),
        CASE WHEN fiscal_year IS NULL THEN 'FY20' END AS fiscal_year
  FROM `org-scorecard-286421.aggregate_data.outcomes_overview_fy20` 