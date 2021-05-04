SELECT
    contact_id AS persist_contact_id,
    COUNT(AT_Id) AS at_count,
    SUM(indicator_persisted_at_c) AS persist_count
    
    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    WHERE start_date_c < CURRENT_DATE()
    AND AY_Name = 'AY 2020-21'
    AND college_track_status_c = '15A'
    GROUP BY contact_id