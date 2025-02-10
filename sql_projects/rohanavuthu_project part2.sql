/*  FINAL PART 2.sql
	Rohan Avuthu
	CS 31A, Winter 2023 */

-- uses database created in part 1
use socialmeet;

-- Display all the groups’ details alphabetically by group name.
SELECT *
FROM GROUP_INFO
ORDER BY group_name; -- question 1

-- Find the names of all the users who live in the city of San Francisco.
SELECT first_name, last_name
FROM USER
WHERE city = 'San Francisco'; -- question 2

-- List the names and addresses of all users, alphabetically ordered by last name.
SELECT first_name, last_name, address, city, state, zip_code
FROM USER
ORDER BY last_name; -- question 3

-- Which posts have the word “help” in their contents? List the post content only.
SELECT post_content
FROM USER_POST
WHERE post_content LIKE '%help%'; -- question 4

-- Display the email address and city of all users.
SELECT email, city
FROM USER; -- question 5

-- Display the three users who have sent the most friend requests. Your query should return the user’s last name and number of requests sent.
SELECT u.last_name, COUNT(uf.sender_id) AS num_requests_sent
FROM USER_FRIEND uf
JOIN USER u ON uf.sender_id = u.user_id
GROUP BY uf.sender_id
ORDER BY num_requests_sent DESC
LIMIT 3; -- question 6

-- Determine the number of accepted friend requests.
SELECT COUNT(u_status) AS 'accepted friend requests'
FROM USER_FRIEND
WHERE u_status = 'accepted'; -- question 7 

-- Display the percentage of requests who were accepted.
SELECT COUNT(u_status) AS 'accepted friend requests',
       (COUNT(u_status) * 100 / COUNT(*)) AS 'acceptance rate'
FROM USER_FRIEND
WHERE u_status = 'accepted'; -- question 8 

-- Determine the users with more than 10 unread messages and how many unread messages each have.
SELECT to_user_id, COUNT(*) AS num_unread_messages
FROM USER_MESSAGE
WHERE date_read IS NULL
GROUP BY to_user_id
HAVING COUNT(*) > 10; -- question 9 

-- Display posts which don’t have any comments.
SELECT *
FROM USER_POST
LEFT JOIN POST_COMMENTS ON USER_POST.post_id = POST_COMMENTS.post_id
WHERE POST_COMMENTS.comment_id IS NULL; -- question 10

-- Calculate how many groups are currently open, waiting for approval, and/or closed.
SELECT join_mode, COUNT(*) AS num_groups
FROM GROUP_INFO
GROUP BY join_mode;  -- question 11

-- Display the five most popular group categories.
SELECT CATEGORY.category_name, COUNT(*) AS num_groups
FROM GROUP_INFO
JOIN CATEGORY ON GROUP_INFO.category_id = CATEGORY.category_id
GROUP BY CATEGORY.category_name
ORDER BY num_groups DESC
LIMIT 5;  -- question 12

-- Display the five least popular group categories?
SELECT CATEGORY.category_name, COUNT(*) AS num_groups
FROM GROUP_INFO
JOIN CATEGORY ON GROUP_INFO.category_id = CATEGORY.category_id
GROUP BY CATEGORY.category_name
ORDER BY num_groups ASC
LIMIT 5;  -- question 13

-- Calculate how many members SocialMeet has.
SELECT COUNT(user_id) AS 'total users'
FROM USER; -- question 14

-- Calculate the longest running group on SocialMeet and how many members belong in that group.
SELECT title, members
FROM GROUP_INFO
ORDER BY created ASC
LIMIT 1; -- question 15 












