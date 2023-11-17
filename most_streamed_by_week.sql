/*
The below query ranks songs by the number of streams for each week.
*/
SELECT 
   RANK() OVER (
      PARTITION BY week
      ORDER BY streams_millions desc
   ) AS 'rank', 
   artist, 
   week,
   streams_millions
FROM
   streams;


/*
The below query groups songs in to quartiles by week based on the number of streams (top 25% are group 1, next 25% group 2, etc)
*/
SELECT 
   NTILE(4) OVER (
      PARTITION BY week
      ORDER BY streams_millions DESC
   ) AS 'weekly_streams_group', 
   artist, 
   week,
   streams_millions
FROM
   streams;