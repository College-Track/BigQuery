CREATE
OR REPLACE FUNCTION `learning-agendas.growth_model.calc_projection`(
  AT_Grade_c STRING,
  base_count FLOAT64,
  nine_grade FLOAT64,
  tenth_grade FLOAT64,
  eleven_grade FLOAT64,
  twelve_grade FLOAT64,
  year_1 FLOAT64,
  year_2 FLOAT64,
  year_3 FLOAT64,
  year_4 FLOAT64,
  year_5 FLOAT64,
  year_6 FLOAT64,
  year_7 FLOAT64,
  year_8 FLOAT64
) AS (
  CASE
    WHEN AT_Grade_c = '9th Grade' THEN base_count * (tenth_grade / nine_grade)
    WHEN AT_Grade_c = '10th Grade' THEN base_count * (eleven_grade / tenth_grade)
    WHEN AT_Grade_c = '11th Grade' THEN base_count * (twelve_grade / eleven_grade)
    WHEN AT_Grade_c = '12th Grade' THEN base_count * (year_1 / twelve_grade)
    WHEN AT_Grade_c = 'Year 1' THEN base_count * (year_2 / year_1)
    WHEN AT_Grade_c = 'Year 2' THEN base_count * (year_3 / year_2)
    WHEN AT_Grade_c = 'Year 3' THEN base_count * (year_4 / year_3)
    WHEN AT_Grade_c = 'Year 4' THEN base_count * (year_5 / year_4)
    WHEN AT_Grade_c = 'Year 5' THEN base_count * (year_6 / year_5)
    WHEN AT_Grade_c = 'Year 6' THEN base_count * (year_7 / year_6)
    WHEN AT_Grade_c = 'Year 7' THEN base_count * (year_8 / year_7)
    ELSE 0
    END
  );