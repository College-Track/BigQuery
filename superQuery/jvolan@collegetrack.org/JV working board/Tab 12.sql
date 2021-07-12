 SELECT
 AT_Name,
 full_name_c,
 AT_Cumulative_GPA,
SUM(
CASE
WHEN previous_as_c = true THEN 1
ELSE 0
END) AS prev_at_count,

 FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
 WHERE college_track_status_c = '15A'
 AND previous_as_c = TRUE
 GROUP by AT_name,full_name_c,AT_Cumulative_GPA