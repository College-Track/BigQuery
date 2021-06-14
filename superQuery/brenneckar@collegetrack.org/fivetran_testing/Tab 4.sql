SELECT site_short, COUNT(Contact_Id)
FROM `data-warehouse-289815.salesforce_clean.contact_template`
WHERE site_short = 'Aurora'
AND college_track_status_c = '11A'