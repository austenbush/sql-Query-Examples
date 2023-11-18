/* seeing percentage of people who answered each subsequent question in a survey from the same table */
select question_text,
cast(num as real) / lag(num,1,num) over (order by question_text)
from
  (select question_text,
    count(distinct user_id) as num
  from survey_responses
  group by question_text) as db


/* getting rows of people to see amount that fell off from browse to checkout to purchase from multiple tables */
/* these values are grouped by the date the customers were on the site in order to see changes over time and variation on particular days */
with funnels as (
  select distinct b.browse_date,
     b.user_id,
     c.user_id is not null as 'is_checkout',
     p.user_id is not null as 'is_purchase'
  from browse b
  left join checkout c
    on c.user_id = b.user_id
  left join purchase p
    on p.user_id = c.user_id)
select 
browse_date,
count(*) as 'num_browse',
sum(is_checkout) as 'num_checkout',
sum(is_purchase) as 'num_purchase',
1.0 * sum(is_checkout) / count(user_id) as 'checkout_percent',
1.0 * sum(is_purchase) / sum(is_checkout) as 'purchase_percent'
from funnels
group by browse_date;


/* comparing funnels for A/B Tests (control vs variant survey) in the same table */
SELECT modal_text,
  COUNT(DISTINCT CASE
    WHEN ab_group = 'control' THEN user_id
    END) as control_clicks,
    COUNT(DISTINCT CASE
    WHEN ab_group = 'variant' THEN user_id
    END) as variant_clicks
FROM onboarding_modals
GROUP BY modal_text
ORDER BY modal_text;

/* see if the number of pairs for a take home test changes the likelihood of purchase */
 select
 count(distinct q.user_id) as 'users',
 number_of_pairs,
 count(distinct case when p.user_id is not null then p.user_id end) as 'is_purchase'
 from quiz q left join home_try_on h on q.user_id = h.user_id
 left join purchase p on h.user_id = p.user_id
 group by number_of_pairs;