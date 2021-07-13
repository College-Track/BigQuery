SELECT Contact_Id, SUM(enrolled_sessions_c)
FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
WHERE AY_Name IN ('AY 2018-19', 'AY 2019-20')
GROUP BY Conact_id, AY_Name