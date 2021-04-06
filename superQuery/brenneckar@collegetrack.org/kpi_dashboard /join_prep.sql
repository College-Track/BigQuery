WITH gahter_data AS (SELECT "national" AS national,
site_short,
region_short,
Contact_Record_Type_Name,
COUNT(Contact_Id) AS student_count
FROM `data-warehouse-289815.salesforce_clean.contact_template`
WHERE college_track_status_c IN ('11A', '15A')
GROUP BY site_short,
region_short,
Contact_Record_Type_Name
)

SELECT 
national,
site_short,
region_short,
MAX(IF(Contact_Record_Type_Name = "Student: Post-Secondary", student_count, NULL)) AS ps_student_count,
MAX(IF(Contact_Record_Type_Name = "Student: High School", student_count, NULL)) AS hs_student_count,
FROM gather_data
GROUP BY
national,
site_short,
region_short