SELECT 
    at_id,
    contact_id,
    AY_Name,
    site_c

FROM `data-warehouse-289815.salesforce_clean.contact_at_template` 
WHERE record_type_id = '01246000000RNnSAAW' 
    AND site_short != 'College Track Arlen'
    AND AY_Name = 'AY 2020-21'
    AND College_Track_Status_Name = 'Current CT HS Student'