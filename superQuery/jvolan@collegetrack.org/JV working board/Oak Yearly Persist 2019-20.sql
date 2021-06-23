WITH set_reporting_group AS
(    
    SELECT
    contact_id,
    CASE
        WHEN
        (enrolled_in_any_college_c = true
        AND student_audit_status_c = 'Active: Post-Secondary') THEN 1
        ELSE 0
    END AS include_in_reporting_group
    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    WHERE AY_Name = 'AY 2019-20'
    AND term_c = 'Fall'
),

get_persist_at_data AS
(
  SELECT
    CAT.site_short,
    CAT.contact_id AS persist_contact_id,
    COUNT(AT_Id) AS at_count,
--for those same records, counting # of ATs for each student in which they met term to term persistence definition
    SUM(CASE
        WHEN
        student_audit_status_c = 'CT Alumni' 
        OR indicator_persisted_at_c = 1 THEN 1
        ELSE 0
    END) AS indicator_persisted_at,
    MAX(set_reporting_group.include_in_reporting_group) AS include_in_reporting_group,

    FROM `data-warehouse-289815.salesforce_clean.contact_at_template` CAT
    LEFT JOIN set_reporting_group ON set_reporting_group.contact_id = CAT.Contact_Id
    WHERE 
    (AY_Name = 'AY 2019-20'
    AND term_c IN ('Winter','Spring'))
    OR
    (AY_Name = 'AY 2020-21'
    AND term_c = 'Fall')
    GROUP BY CAT.contact_id,
    CAT.site_short
),

--actually comparing the # terms vs. # of terms meeting persistence defintion, per student
persist_calc AS
(
    SELECT
    persist_contact_id,
    site_short,
    MAX(include_in_reporting_group) AS cc_persist_denom,
  -- if # terms = # of terms meeting persistence defintion, student will be in numerator
    MAX(
    CASE
        WHEN at_count = indicator_persisted_at THEN 1
        ELSE 0
    END) AS indicator_persisted
    FROM get_persist_at_data
    WHERE include_in_reporting_group = 1
    GROUP BY persist_contact_id, 
    site_short
)
    SELECT
    site_short,
    sum(indicator_persisted) AS indicator_persisted,
    sum(cc_persist_denom) AS denominator_reporting_group,
    (sum(indicator_persisted)/sum(cc_persist_denom)*100) as percent_persisted
    FROM persist_calc
    GROUP BY site_short

    
    
