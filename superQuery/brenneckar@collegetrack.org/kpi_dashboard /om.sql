WITH gather_data AS (
SELECT CT.site_short, COUNT(S.contact_id) as completion_count
FROM `data-studio-260217.surveys.fy21_hs_survey` S
LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_template` CT ON CT.Contact_Id = S.contact_id

GROUP BY CT.site_short
)

SELECT GD.site_short,
MAX(GD.completion_count) AS completion_count,
SUM(SC.student_count) AS student_denominator
from gather_data GD
LEFT JOIN `data-studio-260217.surveys.fy21_hs_survey_completion` SC ON SC.site_short = GD.site_short
GROUP BY GD.site_short