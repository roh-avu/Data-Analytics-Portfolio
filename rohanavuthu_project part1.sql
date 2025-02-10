/*  FINAL PART 1.sql
	Rohan Avuthu
	CS 31A, Winter 2023 */

-- Creating database
delimiter ;
DROP DATABASE IF EXISTS socialmeet;
CREATE DATABASE socialmeet;
use socialmeet;

-- remove any prior version of tables

DROP TABLE IF EXISTS USER;
DROP TABLE IF EXISTS USER_FRIEND; 
DROP TABLE IF EXISTS USER_MESSAGE;
DROP TABLE IF EXISTS USER_POST;
DROP TABLE IF EXISTS CATEGORY;
DROP TABLE IF EXISTS POST_COMMENTS;
DROP TABLE IF EXISTS GORUP_INFO;
DROP TABLE IF EXISTS GORUP_MEMBER;
DROP TABLE IF EXISTS GROUP_POST;
DROP TABLE IF EXISTS GROUP_MESSAGE;
DROP TABLE IF EXISTS CITY;

-- The USER table contains data on individual users such as user ID, username, email, profile, etc.
CREATE TABLE USER (
    user_id        INT  NOT NULL,
    first_name     VARCHAR(50) NOT NULL,
    last_name      VARCHAR(50) NOT NULL,
    city           VARCHAR(50) NOT NULL,
    state          VARCHAR(50) NOT NULL,
    zip_code       VARCHAR(10) NOT NULL,
    address        VARCHAR(50) NOT NULL,
    country        VARCHAR(50) NOT NULL,
    phone          VARCHAR(20) NOT NULL,
    email          VARCHAR(100) NOT NULL,
    user_password  VARCHAR(100) NOT NULL,
    created_by     VARCHAR(100) NOT NULL,
    updated_by     VARCHAR(100) NOT NULL,
    
    PRIMARY KEY (user_id)
);

-- The USER_FRIEND table contains data about the name of each user friend’s ID, action, and status.
CREATE TABLE USER_FRIEND (
    request_id     INT  NOT NULL,
    sender_id      INT NOT NULL,
    receiver_id    INT NOT NULL,
    u_status       ENUM('pending', 'accepted', 'rejected') DEFAULT 'pending',
    action_time    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    action_taken   VARCHAR(255),
    PRIMARY KEY    (request_id),
    FOREIGN KEY    (sender_id) REFERENCES USER(user_id),
    FOREIGN KEY    (receiver_id) REFERENCES USER(user_id)
);

-- We will design the USER_MESSAGE table to store the user chat messages.
CREATE TABLE USER_MESSAGE (
  message_id       INT  NOT NULL,
  from_user_id     INT NOT NULL,
  to_user_id       INT NOT NULL,
  message_tex      TEXT NOT NULL,
  date_sent        TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  date_read        TIMESTAMP NULL DEFAULT NULL
);

-- We will design the USER_POST table to store data on what the users post. 
CREATE TABLE USER_POST (
  post_id          INT  NOT NULL,
  user_id          INT NOT NULL,
  sender_id        INT NOT NULL,
  post_content     TEXT NOT NULL,
  created_at       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at       TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (post_id)
);

-- The CATEGORY table contains information about each category.
CREATE TABLE CATEGORY (
	category_id    INT NOT NULL, 
    category_name  VARCHAR(30) NOT NULL,
    PRIMARY KEY (category_id)
);

-- Info about POST_COMMENTS
CREATE TABLE POST_COMMENTS (
	comment_id     INT NOT NULL,
	user_id        INT NOT NULL,
	user_comment   TEXT,
	created_date   DATETIME NOT NULL,
	post_id        INT NOT NULL,
	PRIMARY KEY (comment_id),
	FOREIGN KEY (user_id) REFERENCES USER(user_id),
	FOREIGN KEY (post_id) REFERENCES USER_POST(post_id)
);

-- We have a GROUP_INFO table to store group data about the groups who use SocialMeet to network.
CREATE TABLE GROUP_INFO (
  group_id         INT NOT NULL,
  category_id      INT NOT NULL,
  created          DATETIME NOT NULL,
  created_by       INT NOT NULL,
  updated_by       INT NOT NULL,
  title            VARCHAR(255) NOT NULL,
  join_mode        ENUM('open', 'closed') NOT NULL,
  group_name       VARCHAR(255) NOT NULL,
  visibility       ENUM('public', 'private') NOT NULL,
  members          INT NOT NULL,
  PRIMARY KEY (group_id),
  FOREIGN KEY (category_id) REFERENCES CATEGORY (category_id),
  FOREIGN KEY (created_by) REFERENCES USER (user_id),
  FOREIGN KEY (updated_by) REFERENCES USER (user_id)
);


-- The GROUP_MEMBER table contains data on individual users. Each row lists one user and one group.
CREATE TABLE GROUP_MEMBER (
    member_id      INT NOT NULL,
    city           VARCHAR(50) NOT NULL,
    country        VARCHAR(50) NOT NULL,
    joined         DATE NOT NULL,
    member_status  VARCHAR(20) NOT NULL,
    group_id       INT NOT NULL,
    PRIMARY KEY (member_id),
    FOREIGN KEY (group_id) REFERENCES GROUP_INFO(group_id)
);

-- We will design the GROUP_POST table to store group posts.
CREATE TABLE GROUP_POST (
    post_id        INT NOT NULL AUTO_INCREMENT,
    group_id       INT NOT NULL,
    user_id        INT NOT NULL,
    message        TEXT NOT NULL,
    created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (post_id),
    FOREIGN KEY (group_id) REFERENCES GROUP_INFO(group_id),
    FOREIGN KEY (user_id) REFERENCES USER(user_id)
);
    
-- Info on messages in groups 
CREATE TABLE GROUP_MESSAGE (
   message_id      INT PRIMARY KEY AUTO_INCREMENT,
   group_id        INT NOT NULL,
   user_id         INT NOT NULL,
   message         VARCHAR(255) NOT NULL,
   created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
   updated_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
   FOREIGN KEY (group_id) REFERENCES GROUP_INFO (group_id),
   FOREIGN KEY (user_id) REFERENCES USER (user_id)
);

-- The CITY table contains information about each city.
CREATE TABLE CITY (
   city_id        INT PRIMARY KEY AUTO_INCREMENT,
   city_name      VARCHAR(50) NOT NULL,
   state          VARCHAR(50) NOT NULL,
   zip            VARCHAR(10) NOT NULL,
   country        VARCHAR(50) NOT NULL
);







