SELECT Count(Contact_Id)
FROM `data-warehouse-289815.salesforce_clean.contact_template`
WHERE site_short = 'Oakland'
AND college_track_status_c = '15A'