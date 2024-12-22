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