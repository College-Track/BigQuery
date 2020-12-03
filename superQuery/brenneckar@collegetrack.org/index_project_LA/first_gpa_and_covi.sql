WITH valid_gpa_terms AS (
  SELECT
    Contact_Id,
    AT_Id,
    AT_Grade_c,
    term_c,
    gpa_semester_cumulative_c,
  FROM
    `data-warehouse-289815.salesforce_clean.contact_at_template`
  WHERE
    college_track_status_c IN ('11A')
    AND gpa_semester_cumulative_c IS NOT NULL
    AND AT_Grade_c IN ('9th Grade', '10th Grade')
    AND term_c != 'Summer'
  ORDER BY
    Contact_Id,
    AT_Grade_c,
    term_c
)
, first_gpa_value AS (
SELECT Contact_Id, 
  FIRST_VALUE(gpa_semester_cumulative_c)
    OVER (PARTITION BY Contact_Id ORDER BY AT_Grade_c,
    term_c
    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS first_gpa
FROM valid_gpa_terms
), 

valid_covi_terms AS (
  SELECT
    Contact_Id,
    AT_Id,
    AT_Grade_c,
    term_c,
    co_vitality_scorecard_color_c,
  FROM
    `data-warehouse-289815.salesforce_clean.contact_at_template`
  WHERE
    college_track_status_c IN ('11A')
    AND co_vitality_scorecard_color_c IS NOT NULL
    AND AT_Grade_c IN ('9th Grade', '10th Grade')
    AND term_c != 'Summer'
  ORDER BY
    Contact_Id,
    AT_Grade_c,
    term_c
), 

first_covi_value AS (
SELECT Contact_Id, 
  FIRST_VALUE(co_vitality_scorecard_color_c)
    OVER (PARTITION BY Contact_Id ORDER BY AT_Grade_c,
    term_c
    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS first_covi
FROM valid_covi_terms
)

SELECT GPA.Contact_Id, GPA.first_gpa, CoVi.first_covi
FROM first_gpa_value GPA
LEFT JOIN first_covi_value CoVi ON GPA.Contact_Id = CoVi.Contact_Id