-- Migrate distinct usernames from the bad_posts and the bad_comments tables
INSERT INTO users (username)
  SELECT username
  FROM bad_posts
  UNION
  SELECT username
  FROM bad_comments;


-- Migrate distinct topic names from the bad_posts table
INSERT INTO topics (name)
  SELECT DISTINCT topic
  FROM bad_posts;
