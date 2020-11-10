SELECT  Readiness_Math_Official__c, act_sat_readiness
FROM `data-studio-260217.fit_type_pipeline.aggregate_data`
WHERE act_sat_readiness = "Math"
OR Readiness_Math_Official__c = "1. Ready"
GROUP BY Readiness_Math_Official__c, act_sat_readiness