WITH get_persist_at_data AS
(
  SELECT
    contact_id AS persist_contact_id,
    Gender_c AS persist_contact_gender,
    Ethnic_background_c AS persist_contact_ethnic_background,
--indicator to flag which students were enrolled in any college last fall. used to created denominator later
    MAX(CASE
        WHEN
        (enrolled_in_any_college_c = true
        AND college_track_status_c = '15A'
        AND AY_Name = 'AY 2020-21'
        AND term_c = 'Fall') THEN 1
        ELSE 0
    END) AS include_in_reporting_group,
--counting the # of ATs for each student in this window
    COUNT(AT_Id) AS at_count,
--for those same records, counting # of ATs for each student in which they met term to term persistence definition
    SUM(
        CASE
        WHEN indicator_persisted_at_c =1
        OR student_audit_status_c = 'CT Alumni'THEN 1
    END) AS persist_count

    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
--Start date for PAT must be prior today to be included. To exclude future PATs upon creation, until they become current AT. want to ignore summer too.
    WHERE start_date_c < CURRENT_DATE()
        AND((AY_Name = 'AY 2020-21'
        AND term_c <> 'Summer')
        OR
        (AY_Name = 'AY 2021-22'
        AND term_c = 'Fall'))
    GROUP BY contact_id,
    Gender_c,
    Ethnic_background_c
)
--actually comparing the # terms vs. # of terms meeting persistence defintion, per student

    SELECT
    persist_contact_id,
    persist_contact_gender,
    persist_contact_ethnic_background,

    MAX(include_in_reporting_group) AS cc_persist_denom,
  -- if # terms = # of terms meeting persistence defintion, student will be in numerator
    MAX(
    CASE
        WHEN at_count = persist_count THEN 1
        ELSE 0
    END) AS indicator_persisted
    FROM get_persist_at_data
-- filter out any students who weren't enrolled last fall. denominator
    WHERE include_in_reporting_group = 1
    GROUP BY persist_contact_id,
    persist_contact_gender,
    persist_contact_ethnic_background