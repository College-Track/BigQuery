SELECT CT.site_short, COUNT(distinct(S.contact_id)) as completion_count
FROM `data-studio-260217.surveys.fy21_hs_survey` S
LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_template` CT ON CT.Contact_Id = S.contact_id

GROUP BY CT.site_short