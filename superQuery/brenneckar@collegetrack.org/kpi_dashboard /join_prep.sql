SELECT "national" AS national,
site_short,
region_short,
Contact_Record_Type_Name,
COUNT(Contact_Id)
FROM `data-warehouse-289815.salesforce_clean.contact_template`
WHERE college_track_status_c IN ('11A', '15A')
GROUP BY site_short,
region_short,
Contact_Record_Type_Name