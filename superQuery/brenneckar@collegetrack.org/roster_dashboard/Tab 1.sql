SELECT College_Track_Status_c, HIGH_SCHOOL_GRADUATING_CLASS_c,Contact_Record_Type_Name, COUNT(Contact_Id)
FROM `data-studio-260217.rosters.filtered_roster`
WHERE site_short = 'Ward 8'
GROUP BY College_Track_Status_c,HIGH_SCHOOL_GRADUATING_CLASS_c, Contact_Record_Type_Name