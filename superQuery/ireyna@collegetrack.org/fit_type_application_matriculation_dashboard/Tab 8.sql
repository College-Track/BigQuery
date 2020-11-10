SELECT  Readiness_Composite_Off__c ,Readiness_English_Official__c, Readiness_Math_Official__c, act_sat_readiness
FROM `data-studio-260217.fit_type_pipeline.aggregate_data`
WHERE act_sat_readiness = "Math"
GROUP BY readiness_Composite_Off__c ,Readiness_English_Official__c, Readiness_Math_Official__c, act_sat_readiness