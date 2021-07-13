WITH gather_data AS (SELECT Contact_Id, AY_Name, SUM(attended_workshops_c) AS attended_workshops_c
FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
WHERE AY_Name IN ('AY 2018-19', 'AY 2019-20')
AND site_short IN ('San Francisco', "Oakland", 'East Palo Alto')
AND AT_Grade_c = '12th Grade'
AND high_school_graduating_class_c = '2019'
GROUP BY Contact_Id, AY_Name
)
SELECT AY_Name, COUNT(Contact_Id)
FROM gather_data 
WHERE attended_workshops_c > 0
GROUP BY AY_Name