  SELECT fhoffa.x.nlp_compromise_people(title) names
  FROM `fh-bigquery.reddit_posts.2019_02`
  WHERE subreddit = 'movies'
  LIMIT 10