SELECT
    site_short,
    contact_id AS persist_contact_id,
--indicator to flag which students were enrolled in any college last fall. used to created denominator later
    MAX(CASE
        WHEN
        (enrolled_in_any_college_c = true
        AND student_audit_status_c = 'Active: Post-Secondary'
        AND AY_Name = 'AY 2019-20'
        AND term_c = 'Fall') THEN 1
        ELSE 0
    END) AS include_in_reporting_group,
--counting the # of ATs for each student in this window
    COUNT(AT_Id) AS at_count,
--for those same records, counting # of ATs for each student in which they met term to term persistence definition
    SUM(CASE
        WHEN
        student_audit_status_c = 'CT Alumni' 
        OR indicator_persisted_at_c = 1 THEN 1
    END) AS indicator_persisted_at

    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
--Start date for PAT must be prior today to be included. To exclude future PATs upon creation, until they become current AT. want to ignore summer too.
    WHERE site_short = 'Oakland'
    AND
    (AY_Name = 'AY 2019-20'
    AND term_c <> 'Summer')
    OR
    (AY_Name = 'AY 2020-21'
    AND term_c = 'Fall')
    GROUP BY contact_id,
    site_short