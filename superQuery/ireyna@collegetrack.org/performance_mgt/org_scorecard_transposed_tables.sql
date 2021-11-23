--Houses all org scorecard outcomes across fiscal years as a tranposed table for the DS Overview Page

SELECT 
Objective
,fiscal_year
,EPA
,OAK
,SF
,NOLA
,AUR
,BH
,SAC
,WATTS
,DEN
,PGC
,DC8
,CREN
,DC
,CO
,LA
,NOLA_RG
,NORCAL
,NATIONAL
,NATIONAL_AS_LOCATION
,Measure
 
FROM `org-scorecard-286421.transposed_tables.fy21_org_scorecard_hs_college_transposed` 
UNION ALL
SELECT 
Objective
,fiscal_year
,EPA
,OAK
,SF
,NOLA
,AUR
,BH
,SAC
,WATTS
,DEN
,PGC
,DC8
,CREN
,DC
,CO
,LA
,NOLA_RG
,NORCAL
,NATIONAL
,NATIONAL_AS_LOCATION
,Measure

FROM `org-scorecard-286421.transposed_tables.org_scorecard_fy20_overview`