#Using data-studio-260217.performance_mgt.fy21_eoy_combined_metrics table
/*
ALTER TABLE  `org-scorecard-286421.aggregate_data.org_scorecard_program_fy21`
    ADD COLUMN site_or_region STRING,
    
    ;
    ;
INSERT INTO `org-scorecard-286421.aggregate_data.org_scorecard_program_fy21` (site_or_region) VALUES ('National')
    ; */
    /*
CREATE OR REPLACE TABLE `org-scorecard-286421.aggregate_data.org_scorecard_program_fy21`
OPTIONS
    (
    description="This table pulls org scorecard program outcomes for fy21.  Numerator and denominators are included per site. Does not include graduate/employment outcomes, annual fundraising outcomes, hs capacity, or hr-related outcomes." 
    )
    AS
    */
CREATE TEMP TABLE ORG_SCORECARD_FY21_ADD_COLUMN (site_or_region STRING);
INSERT INTO ORG_SCORECARD_FY21_ADD_COLUMN (site_or_region) VALUES  ('National'),
                                                        ('East Palo Alto'),
                                                        ('Oakland'),
                                                        ('San Francisco'),
                                                        ('New Orleans'),
                                                        ('Aurora'),
                                                        ('Boyle Heights'),
                                                        ('Sacramento'),
                                                        ('Watts'),
                                                        ('Denver'),
                                                        ('The Durant Center'),
                                                        ('Ward 8'),
                                                        ('Crenshaw'),
                                                        ('Northern California'),
                                                        ('Los Angeles'),
                                                        ('New Orleans_RG'),
                                                        ('Colorado'),
                                                        ('Washington DC');
    
--WITH prep_orgscorecard AS (
    SELECT EOY.* , site_or_region
    FROM `data-studio-260217.performance_mgt.fy21_eoy_combined_metrics`  AS EOY
    FULL JOIN ORG_SCORECARD_FY21_ADD_COLUMN AS TEMP ON EOY.site_short=TEMP.site_or_region 