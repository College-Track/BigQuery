   SELECT
        obj1.*, --EXCEPT (Site__Account_Name,Region__Account_Name),
        obj1_b.*,
        obj2.*,
        obj3.*,
        obj4.*,
        obj5.*,
        obj6.*,
        /*CASE 
            WHEN Site__Account_Name = 'College Track East Palo Alto' THEN 'East Palo Alto'
            WHEN Site__Account_Name = 'College Track Oakland' THEN 'Oakland'
            WHEN Site__Account_Name = 'College Track San Francisco' THEN 'San Francisco'
            WHEN Site__Account_Name = 'College Track New Orleans' THEN 'New Orleans'
            WHEN Site__Account_Name = 'College Track Aurora' THEN 'Aurora'
            WHEN Site__Account_Name = 'College Track Boyle Heights' THEN 'Boyle Heights'
            WHEN Site__Account_Name = 'College Track Sacramento' THEN 'Sacramento'
            WHEN Site__Account_Name = 'College Track Watts' THEN 'Watts'
            WHEN Site__Account_Name = 'College Track Denver' THEN 'Denver'
            WHEN Site__Account_Name = 'College Track at The Durant Center' THEN 'The Durant Center'
            WHEN Site__Account_Name = 'College Track Ward 8' THEN 'Ward 8'
            WHEN Site__Account_Name = 'College Track Crenshaw' THEN 'Crenshaw'
        END AS site_short,
        
        CASE 
            WHEN Site__Account_Name = 'College Track East Palo Alto' THEN 'EPA'
            WHEN Site__Account_Name = 'College Track Oakland' THEN 'OAK'
            WHEN Site__Account_Name = 'College Track San Francisco' THEN 'SF'
            WHEN Site__Account_Name = 'College Track New Orleans' THEN 'NOLA'
            WHEN Site__Account_Name = 'College Track Aurora' THEN 'AUR'
            WHEN Site__Account_Name = 'College Track Boyle Heights' THEN 'BH'
            WHEN Site__Account_Name = 'College Track Sacramento' THEN 'SAC'
            WHEN Site__Account_Name = 'College Track Watts' THEN 'WATTS'
            WHEN Site__Account_Name = 'College Track Denver' THEN 'DEN'
            WHEN Site__Account_Name = 'College Track at The Durant Center' THEN 'PGC'
            WHEN Site__Account_Name = 'College Track Ward 8' THEN 'DC8'
            WHEN Site__Account_Name = 'College Track Crenshaw' THEN 'CREN'
        END AS site_abrev,
        
        CASE 
            WHEN Region__Account_Name = 'College Track Northern California Region' THEN 'Northern California'
            WHEN Region__Account_Name = 'College Track Los Angeles Region' THEN 'Los Angeles'
            WHEN Region__Account_Name = 'College Track Colorado' THEN 'Colorado'
            WHEN Region__Account_Name = 'College Track DC' THEN 'DC'
        END AS region_short,
        
        CASE 
            WHEN Region__Account_Name = 'College Track Northern California Region' THEN 'NORCAL'
            WHEN Region__Account_Name = 'College Track Los Angeles Region' THEN 'LA'
            WHEN Region__Account_Name = 'College Track Colorado' THEN 'CO'
            WHEN Region__Account_Name = 'College Track DC' THEN 'DC'
        END AS region_short,*/
        
    FROM `org-scorecard-286421.aggregate_data.objective_1_site` AS obj1 --recruit and retain students
    LEFT JOIN `org-scorecard-286421.aggregate_data.objective_1_region` obj1_b ----recruit and retain students
        ON obj1.Region__Account_Name = obj1_b.Region
    FULL OUTER JOIN  `org-scorecard-286421.aggregate_data.HS_MSE_CoVi_FY20` AS obj2 -- academic & social-emotional growth
        ON obj1.Site__Account_Name = obj2.Account --obj1.Region__Account_Name = obj2.Account AND 
    FULL OUTER JOIN  `org-scorecard-286421.aggregate_data.college_outcomes_fy20` AS obj3 --matriculation & graduates
        ON obj1.Site__Account_Name = obj3.Account --obj1.Region__Account_Name = obj3.Account AND
    FULL OUTER JOIN  `org-scorecard-286421.aggregate_data.college_graduates_outcomes_fy20` AS obj4 --alumni, employment
        ON obj1.Site__Account_Name = obj4.Account --obj1.Region__Account_Name = obj4.Account AND 
    FULL OUTER JOIN  `org-scorecard-286421.aggregate_data.HR_outcomes_tenure_engagement` AS obj5 --hr, diverse staff
        ON obj1.Region__Account_Name = obj5.Region AND obj1.Site__Account_Name = obj5.Site
    FULL OUTER JOIN  `org-scorecard-286421.aggregate_data.financial_sustainability_fy20` AS obj6 --financial sustainability
        ON obj1.Region__Account_Name = obj6.Account AND obj1.Site__Account_Name = obj6.Account