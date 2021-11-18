CREATE TEMP TABLE ORG_SCORECARD_FY21 AS (SELECT * FROM `org-scorecard-286421.aggregate_data.org_scorecard_program_fy21`);
    ALTER TABLE ORG_SCORECARD_FY21
ADD COLUMN site_or_region STRING;
INSERT INTO ORG_SCORECARD_FY21 (site_or_region) VALUES ('National'),('East Palo Alto'),('Oakland');

SELECT * FROM ORG_SCORECARD_FY21;