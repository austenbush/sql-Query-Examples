/* Below shows example queries with increasing complexity for calculating churn */

/*
This query calculates the rate of churn (cancellations / total subscribers) for a single month
*/

SELECT 1.0 * 
(
  SELECT COUNT(*)
  FROM subscriptions
  WHERE subscription_start < '2017-01-01'
  AND (
    subscription_end
    BETWEEN '2017-01-01'
    AND '2017-01-31'
  )
) / (
  SELECT COUNT(*) 
  FROM subscriptions 
  WHERE subscription_start < '2017-01-01'
  AND (
    (subscription_end >= '2017-01-01')
    OR (subscription_end IS NULL)
  )
) 
AS result;


/*
Single month churn with temporary tables
*/
WITH enrollments AS 
(SELECT *
FROM subscriptions
WHERE subscription_start < '2017-01-01'
AND (
  (subscription_end >= '2017-01-01')
  OR (subscription_end IS NULL)
)),
status AS 
(SELECT 
CASE
  WHEN (subscription_end > '2017-01-31')
    OR (subscription_end IS NULL) THEN 0
  ELSE 1
  END as is_canceled,
CASE
  WHEN (subscription_start < '2017-01-01')
    AND (
      (subscription_end >= '2017-01-01')
        OR (subscription_end IS NULL)
    ) THEN 1
    ELSE 0
  END as is_active
FROM enrollments
)
SELECT 1.0 * SUM(is_canceled)/SUM(is_active) FROM status;



/* 
T-SQL for churn with declared dates for ease of adjustment 
*/

DECLARE @MonthEnd DATE = '2017-01-31';
DECLARE @MonthStart DATE = '2017-01-01';

with enrollment as (
  select * 
  from subscriptions
  where subscription_start < @MonthStart
  and ((subscription_end >= @MonthStart) or (subscription_end is null))
  ),
  status as (
    select case when (subscription_end > @MonthEnd) 
      or (subscription_end is null) then 0
      else 1 end as is_canceled,
      case when subscription_start < @MonthStart
        and ((subscription_end > @MonthEnd) or (subscription_end is null))then 0 
        else 1 end as is_active
        from enrollment
  )

select 1.0 * sum(is_canceled) / sum(is_active) from status;


/*
Multiple month churn using temporary tables
*/

WITH months AS
(SELECT
  '2017-01-01' as first_day,
  '2017-01-31' as last_day
UNION
SELECT
  '2017-02-01' as first_day,
  '2017-02-28' as last_day
UNION
SELECT
  '2017-03-01' as first_day,
  '2017-03-31' as last_day
),
cross_join AS
(SELECT *
FROM subscriptions
CROSS JOIN months),
status AS
(SELECT id, first_day as month,
CASE
  WHEN (subscription_start < first_day)
    AND (
      subscription_end > first_day
      OR subscription_end IS NULL
    ) THEN 1
  ELSE 0
END as is_active,
CASE 
  WHEN subscription_end BETWEEN first_day AND last_day THEN 1
  ELSE 0
END as is_canceled
FROM cross_join),
status_aggregate AS
(SELECT
  month,
  SUM(is_active) as active,
  SUM(is_canceled) as canceled
FROM status
GROUP BY month)
-- add your churn calculation here
select 
  month,
  1.0 * canceled / active as churn_rate
from status_aggregate