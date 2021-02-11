WITH workshop_enrolled AS
(
SELECT
    COUNT(Class__c) AS workshops_enrolled,
    Academic_Semester__c,
    FROM `data-warehouse-289815.salesforce_raw.Class_Registration__c`
    WHERE Status__c = 'Enrolled'
    GROUP BY Academic_Semester__c
)

SELECT
--basic contact info & demos
    Contact_Id,
    Full_Name_c,
    site_abrev AS Site,
    region_abrev AS region,
    AT_Name,
    AT_Id,
    workshop_enrolled.Academic_Semester__c,
    workshop_enrolled.workshops_enrolled,
    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    LEFT JOIN workshop_enrolled ON workshop_enrolled.Academic_Semester__c = AT_Id
    WHERE current_as_c = TRUE
    AND college_track_status_c IN ("11A", "12A")