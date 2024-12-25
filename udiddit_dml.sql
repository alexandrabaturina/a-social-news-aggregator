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


-- Migrate data to the posts table
INSERT INTO posts(title, topic_id, user_id, url, text_content)
SELECT
  bp.title::VARCHAR(100),
  t.id,
  u.id,
  bp.url,
  bp.text_content
FROM bad_posts bp
JOIN users u
ON bp.username = u.username
JOIN topics t
ON bp.topic = t.name;
