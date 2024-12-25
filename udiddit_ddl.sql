-- Create the users table
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  username VARCHAR(25) NOT NULL,
  last_logon_date DATE,
  CONSTRAINT username_length CHECK (LENGTH(TRIM(username)) > 0)
);

-- List all users who haven't logged in in the last year
CREATE INDEX idx_users_last_logon_date ON users (last_logon_date DESC);

-- Find a user by their username
CREATE UNIQUE INDEX idx_users_username ON users (LOWER(username));


-- Create the topics table
CREATE TABLE topics (
  id SERIAL PRIMARY KEY,
  name VARCHAR(30) NOT NULL,
  description VARCHAR(500) DEFAULT NULL,
  CONSTRAINT topic_name_length CHECK (LENGTH(TRIM(name)) > 0)
);

-- Find a topic ty its name
CREATE UNIQUE INDEX idx_topics_name ON topics (LOWER(name) ASC);


-- Create the posts table
CREATE TABLE posts (
  id SERIAL PRIMARY KEY,
  title VARCHAR(100) NOT NULL,
  topic_id INTEGER,
  post_date TIMESTAMP,
  user_id INTEGER,
  url VARCHAR(500) DEFAULT NULL,
  text_content VARCHAR(1000) DEFAULT NULL,
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
