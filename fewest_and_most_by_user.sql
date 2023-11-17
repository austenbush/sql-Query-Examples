/*
This query shows the smallest number of posts and greatest number of posts for each user.
*/
SELECT 
   username,
   posts,
   FIRST_VALUE (posts) OVER (
      PARTITION BY username 
      ORDER BY posts
   ) AS 'fewest_posts',
   LAST_VALUE (posts) OVER (
      PARTITION BY username 
      ORDER BY posts
      RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
   ) AS 'most_posts'
FROM social_media;