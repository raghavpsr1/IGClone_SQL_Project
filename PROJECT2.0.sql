use ig_clone;
-- 1.Create an ER diagram or draw a schema for the given database.
-- 2.We want to reward the user who has been around the longest, Find the 5 oldest users.
select * from  users Order by created_at limit 5;
-- 3.To target inactive users in an email ad campaign, find the users who have never posted a photo.
select id,username from users where id not in (
select user_id from photos group by user_id ) order by id;

-- 4.Suppose you are running a contest to find out who got the most likes on a photo. Find out who won?
create view photos_tlikes as
select photo_id,count(photo_id) as Total_likes 
from likes group by photo_id order by Total_likes desc ;
 
select * from photos_tlikes;

select photo_id,p.user_id,username,Total_likes from photos p join photos_tlikes pl on p.id=pl.photo_id
join users u on u.id=p.user_id order by Total_likes desc limit 1;

-- 5.The investors want to know how many times does the average user post.

create temporary table posts (select user_id,count(*) as no_of_posts from photos group by user_id);
select avg(no_of_posts) from posts;

-- 6.A brand wants to know which hashtag to use on a post, and find the top 5 most used hashtags.
create view tagid_name as 
select tag_id,tag_name from photo_tags pt join tags t on pt.tag_id=t.id ;
select * from tagid_name;
select *,count(tag_id) from tagid_name group by tag_id order by Count(tag_id) desc limit 5;

-- 7.To find out if there are bots, find users who have liked every single photo on the site.
with cte as
(select user_id,count(user_id) as tl from likes group by user_id having tl =
(select count(distinct id) from photos))
select user_id,username,tl from cte join users u on u.id=cte.user_id ;

-- 8.Find the users who have created instagramid in may and select top 5 newest joinees from it?

select * from users where monthname(created_at)='May' order by created_at desc limit 5;

-- 9.Can you help me find the users whose name starts with c and ends with any number 
-- and have posted the photos as well as liked the photos?
select distinct u.id,u.username from users u join photos p 
on u.id=p.user_id join likes l
on u.id=l.user_id where u.username regexp '^c' and u.username rlike '[0-9]$';

-- 10.Demonstrate the top 30 usernames to the company who have posted photos in the range of 3 to 5.
create view user_tposts as
select user_id,count(user_id) as total_posts from photos group by user_id;
select * from user_tposts;
select user_id,username,total_posts from user_tposts ups join users u on ups.user_id=u.id
 where total_posts in (3,4,5) order by total_posts desc limit 30;
 
 
 





































