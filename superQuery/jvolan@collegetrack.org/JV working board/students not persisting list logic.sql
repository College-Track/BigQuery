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
    CAT.full_name_c,
    CAT.high_school_graduating_class_c,
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
    CAT.site_short,
    CAT.full_name_c,
    CAT.high_school_graduating_class_c
),

--actually comparing the # terms vs. # of terms meeting persistence defintion, per student
persist_calc AS
(
    SELECT
    persist_contact_id,
    site_short,
    full_name_c,
    high_school_graduating_class_c,
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
    site_short,
    full_name_c,
    high_school_graduating_class_c
)
    SELECT
    persist_contact_id,
    site_short,
    full_name_c,
    high_school_graduating_class_c,
    indicator_persisted,
    
    FROM persist_calc
    WHERE indicator_persisted = 0
    AND site_short = 'Oakland'