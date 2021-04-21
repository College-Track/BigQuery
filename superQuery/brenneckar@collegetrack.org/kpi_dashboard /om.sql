WITH gather_data AS (
SELECT CT.site_short, COUNT(S.contact_id) as completion_count,
SUM(SC.student_count) AS student_denominator
FROM `data-studio-260217.surveys.fy21_hs_survey` S
LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_template` CT ON CT.Contact_Id = S.contact_id
LEFT JOIN `data-studio-260217.surveys.fy21_hs_survey_completion` SC ON SC.site_short = CT.site_short
GROUP BY CT.site_short
)

SELECT *
from gather_data