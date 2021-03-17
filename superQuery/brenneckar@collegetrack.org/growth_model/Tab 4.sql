CREATE TEMP FUNCTION expand_array(x FLOAT64)
RETURNS ARRAY <FLOAT64>
LANGUAGE js AS r"""
  return [...Array(x).keys()];
""";


WITH numbers AS
  (SELECT 5 AS x, 5 as y)

SELECT *
FROM numbers
-- SELECT name, COUNT(*) c
-- FROM (
--   SELECT fhoffa.x.nlp_compromise_people(title) names
--   FROM `fh-bigquery.reddit_posts.2019_02`
--   WHERE subreddit = 'movies'
-- ), UNNEST(names) name