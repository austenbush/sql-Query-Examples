/* 
This query creates a couple of month-to-month running values for the username 'instagram' in this dataset by using some basic window functions on a data set. 
running_total: total change it followers (including previous months)
running_avg: average change in followers, month over month (including previous months)
*/
SELECT 
   month,
   change_in_followers,
   SUM(change_in_followers) OVER (
      ORDER BY month
   ) AS 'running_total',
   AVG(change_in_followers) OVER (
      ORDER BY month
   ) AS 'running_avg'
FROM
   social_media
WHERE
   username = 'instagram';