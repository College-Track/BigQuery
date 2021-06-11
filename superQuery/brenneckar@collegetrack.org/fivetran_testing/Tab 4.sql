SELECT COUNT( Contact_Id)
FROM `data-warehouse-289815.salesforce_clean.contact_template`
WHERE college_track_status_c IN ('11A', '15A', '17A')