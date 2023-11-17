/* 
This query creates a couple of month-to-month running values for all users in this dataset by using some basic window functions on a data set. 
running_total: total change it followers (including previous months)
running_avg: average change in followers, month over month (including previous months)
*/
SELECT username, 
    month,
    change_in_followers,
    SUM(change_in_followers) OVER (
      PARTITION BY username
      ORDER BY month
      ) 'running_total_followers_change',
    AVG(change_in_followers) OVER (
      PARTITION BY username
      ORDER BY month
      ) 'running_avg_followers_change'
FROM social_media;