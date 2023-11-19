/*
Below shows a query to get the first touch datetime and first touch source.
*/

WITH first_touch AS (
   SELECT user_id,
      MIN(timestamp) AS 'first_touch_at'
   FROM page_visits
   GROUP BY user_id)
SELECT ft.user_id,
  ft.first_touch_at,
  pv.utm_source
FROM first_touch AS 'ft'
JOIN page_visits AS 'pv'
  ON ft.user_id = pv.user_id
  AND ft.first_touch_at = pv.timestamp;


/*
Same thing as above, but for the last touch
*/

with last_touch as (
SELECT user_id,
MAX(timestamp) AS 'last_touch_at'
FROM page_visits
GROUP BY user_id)

select 
lt.user_id,
lt.last_touch_at,
pv.utm_source
from last_touch as lt
join page_visits as pv
on lt.user_id = pv.user_id
and lt.last_touch_at = pv.timestamp;