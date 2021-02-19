SELECT College_Track_Status_Name, COUNT(Contact_Id)
FROM `data-studio-260217.rosters.filtered_roster`
WHERE site_short = 'Ward 8'
GROUP BY College_Track_Status_Name