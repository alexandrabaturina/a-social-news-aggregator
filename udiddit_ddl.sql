-- Create the users table
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  username VARCHAR(25) UNIQUE NOT NULL,
  last_logon_date DATE,
  CONSTRAINT username_length CHECK (LENGTH(TRIM(username)) > 0)
);

-- List all users who haven't logged in in the last year
CREATE INDEX idx_users_last_logon_date ON users (last_logon_date DESC);


-- Create the topics table
CREATE TABLE topics (
  id SERIAL PRIMARY KEY,
  name VARCHAR(30) UNIQUE NOT NULL,
  description VARCHAR(500) DEFAULT NULL,
  CONSTRAINT topic_name_length CHECK (LENGTH(TRIM(name)) > 0)
);


-- Create the posts table
CREATE TABLE posts (
  id SERIAL PRIMARY KEY,
  title VARCHAR(100) NOT NULL,
  topic_id INTEGER NOT NULL,
  post_date TIMESTAMP,
  user_id INTEGER NOT NULL,
  url VARCHAR(500) DEFAULT NULL,
  text_content VARCHAR(1000) DEFAULT NULL,
  CONSTRAINT topic_title_length
    CHECK (LENGTH(TRIM(title)) > 0),
  CONSTRAINT fk_valid_topic FOREIGN KEY (topic_id)
    REFERENCES topics(id) ON DELETE CASCADE,
  CONSTRAINT fk_valid_user FOREIGN KEY (user_id)
    REFERENCES users(id) ON DELETE SET NULL,
  CONSTRAINT url_or_text CHECK (
    (url IS NULL OR text_content IS NULL)
    AND NOT
    (url IS NULL AND text_content IS NULL)
  )
);

-- List all users who haven't created any posts
CREATE INDEX idx_users_without_posts ON posts (user_id);

-- List all topics that don't have any posts
CREATE INDEX idx_topics_without_posts ON posts (topic_id);

-- List the latest 20 posts for a given topic
CREATE INDEX idx_latest_posts_for_topic ON posts (topic_id, post_date DESC);

-- List the lates 20 posts made by a given_user
CREATE INDEX idx_latest_posts_by_user ON posts (user_id, post_date DESC);

--Find all posts that link to a specific URL
CREATE INDEX idx_post_to_url ON posts (url);


-- Create the comments table
CREATE TABLE comments (
    id SERIAL PRIMARY KEY,
    post_id INTEGER NOT NULL,
    comment_text VARCHAR(1000),
    parent_comment_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    comment_timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT comment_text_length CHECK (LENGTH(TRIM(comment_text)) > 0),
    CONSTRAINT fk_valid_post FOREIGN KEY (post_id)
        REFERENCES posts(id) ON DELETE CASCADE,
    CONSTRAINT fk_valid_parent FOREIGN KEY (parent_comment_id)
        REFERENCES comments(id) ON DELETE CASCADE,
    CONSTRAINT fk_valid_user FOREIGN KEY (user_id)
        REFERENCES users(id) ON DELETE SET NULL
);

-- List all the top-level comments for a given post
CREATE INDEX idx_top_level_comments ON comments (post_id, parent_comment_id);

-- List all the direct children of a parent comment
CREATE INDEX idx_direct_children ON comments (parent_comment_id);

-- List the latest 20 comments made by a given user
CREATE INDEX idx_user_latest_comments
    ON comments (user_id, comment_timestamp DESC);


-- Create the votes table
CREATE TABLE votes (
    id SERIAL PRIMARY KEY,
    post_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    vote INTEGER,
    CONSTRAINT fk_valid_user FOREIGN KEY (user_id)
        REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT fk_valid_post FOREIGN KEY (post_id)
        REFERENCES posts(id) ON DELETE CASCADE,
    CONSTRAINT unique_vote UNIQUE (user_id, post_id),
    CONSTRAINT valid_vote CHECK (vote IN (-1, 1))
);

-- Compute the score of a post
CREATE INDEX idx_post_score(post_id);
