-- Migrate distinct usernames from the bad_posts and the bad_comments tables
INSERT INTO users (username)
  SELECT username
  FROM bad_posts
  UNION
  SELECT username
  FROM bad_comments;
