--Combine Org Scorecard outcomes for FY20-current year, unpivoted


CREATE OR REPLACE TABLE `org-scorecard-286421.aggregate_data.org_scorecard_outcomes`
OPTIONS
    (
    description=
    "This table pulls Org Scorecard outcomes, numerators (where applicable), denominator (where applicable). Query used to create table (12/3/21): https://github.com/College-Track/BigQuery/blob/ab0982ac7376611b3247e7854bcd0853d9dbe5da/superQuery/ireyna@collegetrack.org/performance_mgt/org_scorecard_all.sql. Updated on 1/10/2022 to include additional columns based on data enclosed (from query)"
    )
    AS 




SELECT * FROM `org-scorecard-286421.aggregate_data.org_scorecard_outcomes_all_fy_01_10_2022`