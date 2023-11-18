/*
This query gets the number of orders by the day of the week to see which days get the most orders.
*/
SELECT
case cast (strftime('%w', order_date) as integer)
  when 0 then 'Sunday'
  when 1 then 'Monday'
  when 2 then 'Tuesday'
  when 3 then 'Wednesday'
  when 4 then 'Thursday'
  when 5 then 'Friday'
  else 'Saturday' end as weekday,
COUNT(*)
from bakery
group by 1
order by 2 desc;