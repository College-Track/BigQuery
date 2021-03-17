SELECT name, COUNT(*) c
FROM (
  SELECT fhoffa.x.nlp_compromise_people(title) names
  FROM `fh-bigquery.reddit_posts.2019_02`
  WHERE subreddit = 'movies'
), UNNEST(names) name
WHERE name LIKE '% %'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10