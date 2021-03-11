SELECT Count(( Contact_Id))
FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
WHERE college_track_status_c = '15A' AND current_as_c = true