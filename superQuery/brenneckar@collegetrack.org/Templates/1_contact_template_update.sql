-- Only select Contact records corresponding to valid student records
WITH ValidStudentContact AS (
  SELECT
    C.Id AS Contact_Id,
    C.*
  EXCEPT(
      Id,
      npe01__Secondary_Address_Type__c,
      npe01__SystemAccountProcessor__c,
      npe01__Last_Donation_Date__c,
      npe01__Lifetime_Giving_History_Amount__c,
      npsp__Exclude_from_Household_Formal_Greeting__c,
      npsp__Exclude_from_Household_Informal_Greeting__c,
      npsp__Exclude_from_Household_Name__c,
      npsp__Deceased__c
    ),
    RT.Name AS Contact_Record_Type_Name,
    A_Site.Name AS site,
    A_Region.Name AS region,
    CASE
      WHEN A_Region.Name LIKE '%Northern California%' THEN 'Northern California'
      WHEN A_Region.Name LIKE '%Colorado%' THEN 'Colorado'
      WHEN A_Region.Name LIKE '%Los Angeles%' THEN 'Los Angeles'
      WHEN A_Region.Name LIKE '%New Orleans%' THEN 'New Orleans'
      WHEN A_Region.Name LIKE '%DC%' THEN 'Washington DC'
      ELSE A_Region.Name
    END region_short,
    CASE
      WHEN A_Region.Name LIKE '%Northern California%' THEN 'NOR CAL'
      WHEN A_Region.Name LIKE '%Colorado%' THEN 'CO'
      WHEN A_Region.Name LIKE '%Los Angeles%' THEN 'LA'
      WHEN A_Region.Name LIKE '%New Orleans%' THEN 'NOLA'
      WHEN A_Region.Name LIKE '%DC%' THEN 'DC'
      ELSE A_Region.Name
    END region_abrev,
    CASE
      WHEN A_Site.Name LIKE '%Denver%' THEN 'DEN'
      WHEN A_Site.Name LIKE '%Aurora%' THEN 'AUR'
      WHEN A_Site.Name LIKE '%San Francisco%' THEN 'SF'
      WHEN A_Site.Name LIKE '%East Palo Alto%' THEN 'EPA'
      WHEN A_Site.Name LIKE '%Sacramento%' THEN 'SAC'
      WHEN A_Site.Name LIKE '%Oakland%' THEN 'OAK'
      WHEN A_Site.Name LIKE '%Watts%' THEN 'WATTS'
      WHEN A_Site.Name LIKE '%Boyle Heights%' THEN 'BH'
      WHEN A_Site.Name LIKE '%Ward 8%' THEN 'WARD 8'
      WHEN A_Site.Name LIKE '%Durant%' THEN 'PGC'
      WHEN A_Site.Name LIKE '%New Orleans%' THEN 'NOLA'
      WHEN A_Site.Name LIKE '%Crenshaw%' THEN 'CREN'
      ELSE A_Site.Name
    END site_abrev,
    CASE
      WHEN A_Site.Name LIKE '%Denver%' THEN 'Denver'
      WHEN A_Site.Name LIKE '%Aurora%' THEN 'Aurora'
      WHEN A_Site.Name LIKE '%San Francisco%' THEN 'San Francisco'
      WHEN A_Site.Name LIKE '%East Palo Alto%' THEN 'East Palo Alto'
      WHEN A_Site.Name LIKE '%Sacramento%' THEN 'Sacramento'
      WHEN A_Site.Name LIKE '%Oakland%' THEN 'Oakland'
      WHEN A_Site.Name LIKE '%Watts%' THEN 'Watts'
      WHEN A_Site.Name LIKE '%Boyle Heights%' THEN 'Boyle Heights'
      WHEN A_Site.Name LIKE '%Ward 8%' THEN 'Ward 8'
      WHEN A_Site.Name LIKE '%Durant%' THEN 'The Durant Center'
      WHEN A_Site.Name LIKE '%New Orleans%' THEN 'New Orleans'
      WHEN A_Site.Name LIKE '%Crenshaw%' THEN 'Crenshaw'
      ELSE A_Site.Name
    END site_short,
    STATUS.Status AS College_Track_Status_Name
  FROM
    `data-warehouse-289815.salesforce_raw.Contact` C -- Left join from Contact on to Record Type ID
    LEFT JOIN `data-warehouse-289815.salesforce_raw.RecordType` RT ON C.RecordTypeId = RT.Id -- Left join from Contact on to Account for Site
    LEFT JOIN `data-warehouse-289815.salesforce_raw.Account` A_Site ON C.SITE__c = A_Site.Id -- Left join from Contact on to Account for Site
    LEFT JOIN `data-warehouse-289815.salesforce_raw.Account` A_region ON C.Region__c = A_region.Id
    LEFT JOIN `data-warehouse-289815.roles.ct_status` STATUS ON STATUS.api_name = C.College_Track_Status__c
  WHERE
    -- Filter out test records from the Contact object
    (C.SITE__c != '0011M00002GdtrEQAR') -- Filter out non-active student records from the Contact object
    AND (
      RT.Name = 'Student: High School'
      OR RT.Name = 'Student: Post-Secondary'
      OR RT.Name = 'Student: Alumni'
    )
)
SELECT
  *
FROM
  ValidStudentContact