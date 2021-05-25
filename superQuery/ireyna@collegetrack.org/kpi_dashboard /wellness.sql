SELECT 
    full_name_c,
    at_id,
    contact_id,
    AY_Name,
    site

FROM `data-warehouse-289815.salesforce_clean.contact_at_template` 
WHERE record_type_id = '01246000000RNnSAAW' --HS student
    AND site != 'College Track Arlen'
    AND College_Track_Status_Name = 'Current CT HS Student'