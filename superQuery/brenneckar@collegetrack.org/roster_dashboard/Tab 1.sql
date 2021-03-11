SELECT site_short, Count(( Contact_Id))
FROM `data-studio-260217.rosters.filtered_roster`
WHERE college_track_status_c = '15A'
GROUP BY site_short