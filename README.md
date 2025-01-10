# Udiddit, A Social News Aggregator
## Project Introduction
***Udiddit*** is a social news aggregator, content rating, and discussions website. On ***Udiddit***, registered users are able to link to external content or post their own text content about various topics, ranging from common topics such as photography and food, to more arcane ones such as horse masks or birds with arms. In turn, other users can comment on these posts, and each user is allowed to cast a vote about each post, either in an up (like) or down (dislike) direction.

Unfortunately, due to some time constraints before the initial launch of the site, the data model stored in *Postgres* hasn’t been well thought out, and is starting to show its flaws. You’ve been brought in for two reasons: 
1. To make an assessment of the situation and take steps to fix all the issues with the current data model.
2. Then, once successful, to improve the current system by making it more robust and adding some web analytics.
## Initial Database Schema
The initial schema allows posts to be created by registered users on certain topics, and can include a URL or a text content. It also allows registered users to cast an upvote (like) or downvote (dislike) for any forum post that has been created. In addition to this, the schema also allows registered users to add comments on posts.

The following DDL was used to create the initial schema.
```sql
CREATE TABLE bad_posts (
    id SERIAL PRIMARY KEY,
    topic VARCHAR(50),
    username VARCHAR(50),
    title VARCHAR(150),
    url VARCHAR(4000) DEFAULT NULL,
    text_content TEXT DEFAULT NULL,
    upvotes TEXT,
    downvotes TEXT
);

CREATE TABLE bad_comments (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50),
    post_id BIGINT,
    text_content TEXT
);
```
## New Schema DDL Guidelines
1. A list of features and specifications that Udiddit needs in order to support its website and administrative interface: 
- Allow new users to register: 
    - Each username has to be unique 
    - Usernames can be composed of at most 25 characters 
    - Usernames can’t be empty 
    - We won’t worry about user passwords for this project 
- Allow registered users to create new topics: 
    - Topic names have to be unique. 
    - The topic’s name is at most 30 characters 
    - The topic’s name can’t be empty 
    - Topics can have an optional description of at most 500 characters. 
- Allow registered users to create new posts on existing topics: 
    - Posts have a required title of at most 100 characters 
    - The title of a post can’t be empty. 
    - Posts should contain either a URL or a text content, but not both. 
    - If a topic gets deleted, all the posts associated with it should be automatically deleted too. 
    - If the user who created the post gets deleted, then the post will remain, but it will become dissociated from that user. 
- Allow registered users to comment on existing posts: 
    - A comment’s text content can’t be empty. 
    - Contrary to the current linear comments, the new structure should allow comment threads at arbitrary levels. 
    - If a post gets deleted, all comments associated with it should be automatically deleted too. 
    - If the user who created the comment gets deleted, then the comment will remain, but it will become dissociated from that user. 
    - If a comment gets deleted, then all its descendants in the thread structure should be automatically deleted too. 
- Make sure that a given user can only vote once on a given post: 
    - Hint: you can store the (up/down) value of the vote as the values 1 and -1 respectively. 
    - If the user who cast a vote gets deleted, then all their votes will remain, but will become dissociated from the user. 
    - If a post gets deleted, then all the votes for that post should be automatically deleted too. 
2. A list of queries that Udiddit needs in order to support its website and administrative interface. Note that you don’t need to produce the DQL for those queries: they are only provided to guide the design of your new database schema. 
- List all users who haven’t logged in in the last year. 
- List all users who haven’t created any post. 
- Find a user by their username. 
- List all topics that don’t have any posts. 
- Find a topic by its name. 
- List the latest 20 posts for a given topic. 
- List the latest 20 posts made by a given user. 
- Find all posts that link to a specific URL, for moderation purposes.  
- List all the top-level comments (those that don’t have a parent comment) for a given post. 
- List all the direct children of a parent comment. 
- List the latest 20 comments made by a given user. 
- Compute the score of a post, defined as the difference between the number of upvotes and the number of downvotes 

3. You’ll need to use normalization, various constraints, as well as indexes in your new database schema. You should use named constraints and indexes to make your schema cleaner. 
4. Your new database schema will be composed of five (5) tables that should have an auto-incrementing id as their primary key. 
## Udiddit New Schema
The Udiddit new schema contains five tables:
* users
* topics
* posts
* comments
* votes
![image](https://github.com/user-attachments/assets/c8c7f5ce-ff3f-46b0-b2af-170d98dcfa50)
*The New Schema ERD*

View [SQL queries to create new tables](udiddit-ddl.sql)
