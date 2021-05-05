SELECT
    contact_id AS persist_contact_id,
    MAX(CASE
        WHEN
        (AT_Enrollment_Status_c IN ('Full-time','Part-time')
        AND college_track_status_c = '15A'
        AND AY_Name = 'AY 2020-21'
        AND term_c = 'Fall'
        AND AT_school_type IN ('2-year', '4-year')) THEN 1
        ELSE 0
    END) AS include_in_reporting_group,
    COUNT(AT_Id) AS at_count,
    SUM(indicator_persisted_at_c) AS persist_count
    
    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    WHERE start_date_c < CURRENT_DATE()
    AND AY_Name = 'AY 2020-21'
    AND term_c <> 'Summer'
    GROUP BY contact_id