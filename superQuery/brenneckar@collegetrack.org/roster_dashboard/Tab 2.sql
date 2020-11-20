SELECT current_school_c,   COUNT(*)
FROM `data-warehouse-289815.salesforce.contact`
LEFT JOIN `data-warehouse-289815.salesforce.account` A ON A.Id = Current_school_c
WHERE college_track_status_c = '15A'
GROUP BY Current_school_c