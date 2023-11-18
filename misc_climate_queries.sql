/* see avg temp of time */
select state,
year,
tempf,
AVG(tempf) OVER (partition by state order by year) as running_avg_temp
from state_climate;


/* see lowest and highest temp years by state */
select state,
year,
tempf,
FIRST_VALUE(tempf) OVER (partition by state order by tempf) as lowest_temp,
LAST_VALUE(tempf) OVER (partition by state order by tempf RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) as highest_temp
from state_climate;


/* see change in temp YOY by state */
select state,
year,
tempf,
tempf - LAG(tempf, 1, tempf) OVER (partition by state order by year) as change_in_temp
from state_climate;


/* rank coldest year/state combos */
select state,
year,
tempf,
RANK() OVER (order by tempf) as coldest_rank
from state_climate;


/* rank hottest year/state combos */
select state,
year,
tempf,
RANK() OVER (order by tempf desc) as hottest_rank
from state_climate;


/* separate coldest yearly temps in quartiles */
select
year,
avg(tempf) as 'Average Temp',
NTILE(4) OVER (order by tempf) as coldest_quartile
from state_climate
group by year;