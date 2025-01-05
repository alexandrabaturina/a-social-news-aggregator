-- Migrate distinct usernames from the bad_posts and the bad_comments tables
INSERT INTO users (username)
  SELECT DISTINCT username
  FROM bad_posts
  UNION
  SELECT DISTINCT username
  FROM bad_comments
  UNION
  SELECT DISTINCT regexp_split_to_table(upvotes, ',')
  FROM bad_posts
  UNION
  SELECT DISTINCT regexp_split_to_table(downvotes, ',')
  FROM bad_posts;


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


-- Migrate data to the comments table
INSERT INTO comments(post_id, comment_text, user_id)
    SELECT
        bp.id,
        bc.text_content,
        u.id
    FROM bad_posts bp
    JOIN bad_comments bc
    ON bp.id = bc.post_id
    JOIN users u
    ON bp.username = u.username;
