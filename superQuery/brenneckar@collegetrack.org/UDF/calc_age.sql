CREATE OR REPLACE FUNCTION `data-warehouse-289815.UDF.calc_age`(as_of_date DATE, date_of_birth DATE) AS (
DATE_DIFF(as_of_date,date_of_birth, YEAR) - 
IF(EXTRACT(MONTH FROM date_of_birth)*100 + EXTRACT(DAY FROM date_of_birth) > EXTRACT(MONTH FROM as_of_date)*100 + EXTRACT(DAY FROM as_of_date),1,0));