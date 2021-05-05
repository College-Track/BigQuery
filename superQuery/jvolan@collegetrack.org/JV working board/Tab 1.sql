WITH get_persist_at_data AS
(
  SELECT
    contact_id AS persist_contact_id,
    COUNT(DISTINCT Contact_Id) AS cc_persist_denom,
    COUNT(AT_Id) AS at_count,
    SUM(indicator_persisted_at_c) AS persist_count
    
    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    WHERE start_date_c < CURRENT_DATE()
    AND AY_Name = 'AY 2020-21'
    AND term_c <> 'Summer'
    AND college_track_status_c = '15A'
    AND
    (AT_Enrollment_Status_c IN ('Full-time','Part-time')
        AND AY_Name = 'AY 2020-21'
        AND term_c = 'Fall'
        AND AT_school_type IN ('2-year', '4-year'))
    GROUP BY contact_id
),

persist_calc AS
(
    SELECT
    persist_contact_id,
    MAX(cc_persist_denom) AS cc_persist_denom,
    MAX(
    CASE
        WHEN at_count = persist_count THEN 1
        ELSE 0
    END) AS indicator_persisted
    FROM get_persist_at_data
    GROUP BY persist_contact_id
)

    SELECT
    *
    FROM persist_calc