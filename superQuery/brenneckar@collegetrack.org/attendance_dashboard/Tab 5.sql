SELECT site_abrev,SUM(Attendance_Numerator__c) AS Num, SUM(Attendance_Denominator__c) AS Den, ROUND(SUM(Attendance_Numerator__c) / SUM(Attendance_Denominator__c),2) AS rate
FROM `data-studio-260217.attendance_dashboard.attendance_filtered_data`
WHERE  Workshop_Global_Academic_Semester__c = 'Fall 2020-21' 
GROUP BY site_abrev