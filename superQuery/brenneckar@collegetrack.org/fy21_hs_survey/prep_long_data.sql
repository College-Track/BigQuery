WITH gather_data AS (
SELECT HSSL.*,
C.site_short, 
C.Most_Recent_GPA_Cumulative_bucket,
C.high_school_graduating_class_c

FROM `data-studio-260217.surveys.fy21_hs_survey_long` HSSL
LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_template` C ON C.Contact_Id = HSSL.contact_id

)


SELECT *
FROM gather_data