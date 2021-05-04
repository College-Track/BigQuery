SELECT
    contact_id AS persist_contact_id,
    COUNT(AT_Id) AS at_count,
    SUM(persistence_at_c) AS persist_count
    
    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    WHERE start_date_c < today()
    AND academic_year_c = 'AY 2020-21'
    GROUP BY contact_id