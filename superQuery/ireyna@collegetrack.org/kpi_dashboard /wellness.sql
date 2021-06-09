with gather_red_blue_covi_at AS ( 
SELECT
        student_c,
        site_short,
        MAX(CASE
            WHEN co_vitality_scorecard_color_c IN ('Blue','Red')
            THEN 1
            ELSE NULL
        END) AS wellness_blue_red_denom
FROM `data-warehouse-289815.salesforce_clean.contact_at_template` 
WHERE grade_c != '8th Grade'
    AND college_track_status_c = '11A'
    AND AY_NAME = "AY 2020-21"
    AND Term_c = "Fall"
    AND grade_c != '8th Grade'
GROUP BY 
    student_c,
    site_short
)

--Sum students that have a red or blue covitality color at some point during 2020-21AY
--sum_of_blue_red_covi AS (
SELECT
        site_short,
        SUM(wellness_blue_red_denom) AS sum_of_blue_red_covi_for_avg #students with blue/red Covitality scorecard colors for denominator
FROM gather_red_blue_covi_at
GROUP BY site_short