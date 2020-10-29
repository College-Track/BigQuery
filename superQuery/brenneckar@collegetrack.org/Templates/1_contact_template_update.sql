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
      npsp__Deceased__c,
      Dosage_Rec_CC__c,
      Dosage_Rec_SL__c,
      Program_Rec_NSO__c,
      Program_Rec_Summer_Writing__c,
      OtherStreet,
      OtherCity,
      OtherState,
      OtherPostalCode,
      OtherCountry,
      OtherStateCode,
      OtherCountryCode,
      OtherLatitude,
      OtherLongitude,
      OtherGeocodeAccuracy,
      OtherAddress,
      Salutation,
      MiddleName,
      Fax,
      OtherPhone,
      AssistantPhone,
      ReportsToId,
      Title,
      Department,
      AssistantName,
      LeadSource,
      Description,
      OwnerId,
      HasOptedOutOfEmail,
      HasOptedOutOfFax,
      DoNotCall,
      LastModifiedDate,
      LastModifiedById,
      SystemModstamp,
      LastActivityDate,
      LastCURequestDate,
      LastCUUpdateDate,
      LastViewedDate,
      LastReferencedDate,
      EmailBouncedReason,
      EmailBouncedDate,
      IsEmailBounced,
      PhotoUrl,
      Jigsaw,
      JigsawContactId,
      IndividualId,
      npe01__PreferredPhone__c,
      npe01__Preferred_Email__c,
      npe01__Primary_Address_Type__c,
      npe01__Private__c,
      npe01__SystemIsIndividual__c,
      npe01__Type_of_Account__c,
      npe01__WorkEmail__c,
      npe01__WorkPhone__c,
      npe01__Work_Address__c,
      npo02__AverageAmount__c,
      npo02__Best_Gift_Year_Total__c,
      npo02__Best_Gift_Year__c,
      npo02__FirstCloseDate__c,
      npo02__Formula_HouseholdMailingAddress__c,
      npo02__Formula_HouseholdPhone__c,
      npo02__Household_Naming_Order__c,
      npo02__Household__c,
      npo02__LargestAmount__c,
      npo02__LastCloseDateHH__c,
      npo02__LastCloseDate__c,
      npo02__LastMembershipAmount__c,
      npo02__LastMembershipDate__c,
      npo02__LastMembershipLevel__c,
      npo02__LastMembershipOrigin__c,
      npo02__LastOppAmount__c,
      npo02__MembershipEndDate__c,
      npo02__MembershipJoinDate__c,
      npo02__Naming_Exclusions__c,
      npo02__NumberOfClosedOpps__c,
      npo02__NumberOfMembershipOpps__c,
      npo02__OppAmount2YearsAgo__c,
      npo02__OppAmountLastNDays__c,
      npo02__OppAmountLastYearHH__c,
      npo02__OppAmountLastYear__c,
      npo02__OppAmountThisYearHH__c,
      npo02__OppAmountThisYear__c,
      npo02__OppsClosed2YearsAgo__c,
      npo02__OppsClosedLastNDays__c,
      npo02__OppsClosedLastYear__c,
      npo02__OppsClosedThisYear__c,
      npo02__SmallestAmount__c,
      npo02__Soft_Credit_Last_Year__c,
      npo02__Soft_Credit_This_Year__c,
      npo02__Soft_Credit_Total__c,
      npo02__Soft_Credit_Two_Years_Ago__c,
      npo02__SystemHouseholdProcessor__c,
      npo02__TotalMembershipOppAmount__c,
      npo02__TotalOppAmount__c,
      npo02__Total_Household_Gifts__c,
      npsp__Batch__c,
      npsp__Current_Address__c,
      npsp__HHId__c,
      npsp__Primary_Affiliation__c,
      npsp__Soft_Credit_Last_N_Days__c,
      npsp__is_Address_Override__c,
      GW_Volunteers__Unique_Volunteer_Count__c,
      GW_Volunteers__Volunteer_Auto_Reminder_Email_Opt_Out__c,
      GW_Volunteers__Volunteer_Availability__c,
      GW_Volunteers__Volunteer_Last_Web_Signup_Date__c,
      GW_Volunteers__Volunteer_Manager_Notes__c,
      GW_Volunteers__Volunteer_Notes__c,
      GW_Volunteers__Volunteer_Organization__c,
      GW_Volunteers__Volunteer_Skills__c,
      GW_Volunteers__Volunteer_Status__c,
      GW_Volunteers__First_Volunteer_Date__c,
      GW_Volunteers__Last_Volunteer_Date__c,
      GW_Volunteers__Volunteer_Hours__c,
      npsp__Address_Verification_Status__c,
      npsp__Do_Not_Contact__c,
      npsp__First_Soft_Credit_Amount__c,
      npsp__First_Soft_Credit_Date__c,
      npsp__Largest_Soft_Credit_Amount__c,
      npsp__Largest_Soft_Credit_Date__c,
      npsp__Last_Soft_Credit_Amount__c,
      npsp__Last_Soft_Credit_Date__c,
      npsp__Number_of_Soft_Credits_Last_N_Days__c,
      npsp__Number_of_Soft_Credits_Last_Year__c,
      npsp__Number_of_Soft_Credits_This_Year__c,
      npsp__Number_of_Soft_Credits_Two_Years_Ago__c,
      npsp__Number_of_Soft_Credits__c,
      Lead_Source__c,
      stayclassy__Address_Type__c,
      Secondary_Solicitor__c,
      stayclassy__Amount_Donated_in_Last_X_Days__c,
      stayclassy__Amount_Recurring_Donations__c,
      stayclassy__Blog__c,
      stayclassy__Classy_Fundraising_Page_Total__c,
      stayclassy__Classy_Related_Member_Id__c,
      stayclassy__Classy_Username__c,
      stayclassy__Company__c,
      stayclassy__Data_Refreshed_At__c,
      stayclassy__Gender__c,
      stayclassy__Middle_Name__c,
      stayclassy__Number_of_Donations_in_Last_X_Days__c,
      stayclassy__Number_of_Recurring_Donations__c,
      stayclassy__Shirt_Size__c,
      stayclassy__Suffix__c,
      stayclassy__TEST_Email__c,
      stayclassy__Text_Opt_In__c,
      stayclassy__Website__c,
      stayclassy__amount_of_last_donation__c,
      stayclassy__average_donation__c,
      stayclassy__date_of_last_donation__c,
      stayclassy__opt_in__c,
      stayclassy__sc_member_id__c,
      stayclassy__sc_total_donated__c,
      stayclassy__sc_total_donations__c,
      stayclassy__sc_total_fundraising__c,
      MC4SF__MC_Subscriber__c,
      Board_Member__c,
      Fax__c,
      Contact_Category__c,
      Greeting_Preferred_Name__c,
      High_Level_Contact__c,
      Contact_Categories__c,
      Lead_Sources__c,
      Lead_Source_Detail__c,
      Partner_Type__c,
      Top_Target_List__c,
      Active_Board_Membership__c,
      Assistant_Email__c,
      Do_Not_Solicit__c,
      rh2__Currency_Test__c,
      rh2__Describe__c,
      rh2__Formula_Test__c,
      rh2__Integer_Test__c
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