/*
Below is how I would use LEAD and LAG to get changes in values.
These queries both show the change in the number of streams for Lady Gaga week over week as well as her change in chart position.
*/
SELECT
   artist,
   week,
   streams_millions,
   streams_millions - LAG(streams_millions, 1, streams_millions) OVER (
      ORDER BY week 
   ) AS streams_millions_change,
   chart_position,
   LAG(chart_position, 1, chart_position) OVER (
      ORDER BY week
   ) - chart_position AS chart_position_change
FROM
   streams 
WHERE
   artist = 'Lady Gaga';

SELECT
   artist,
   week,
   streams_millions,
   LEAD(streams_millions, 1) OVER (
      PARTITION BY artist
      ORDER BY week
   ) - streams_millions AS 'streams_millions_change',
   chart_position,
   chart_position - LEAD(chart_position, 1) OVER (
      PARTITION BY artist
      ORDER BY week
   ) AS 'chart_position_change'
FROM
   streams;