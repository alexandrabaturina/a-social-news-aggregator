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
