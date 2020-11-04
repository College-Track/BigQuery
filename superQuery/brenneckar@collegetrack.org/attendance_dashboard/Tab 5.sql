SELECT WSA.Id, W.dosage_types_c, W.Id as class
FROM `data-warehouse-289815.salesforce.class_attendance_c` WSA
LEFT JOIN `data-warehouse-289815.salesforce.class_registration_c` WE ON WE.Id = WSA.workshop_enrollment_c
LEFT JOIN `data-warehouse-289815.salesforce.class_c` W ON W.Id = WE.class_c
WHERE W.Id ='a321M000000kkB9QAI'