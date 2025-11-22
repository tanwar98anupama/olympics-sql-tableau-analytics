/* ============================================================
   PROJECT: 120 Years of Olympic Games – SQL Analysis
   DATABASE: Olympics_SQL
   TABLES: athletes, athlete_events
   AUTHOR: Anupama (Anu) – SQL Server
   ============================================================ */



---------------------------------------------------------------
--1 which team has won the maximum gold medals over the years.
---------------------------------------------------------------

select 
  top 1 a.team, 
  count(e.medal) total_medals
from 
  athletes a 
left join 
  athlete_events e
on 
  a.id= e.athlete_id
where 
  e.medal= 'gold'
group by 
  a.team
order by 
  total_medals desc
  
----------------------------------------------------------------------------------------------------------------------------------------------------------
-- 2 for each team print total silver medals and year in which they won maximum silver medal..output 3 columns team,total_silver_medals, year_of_max_silver
----------------------------------------------------------------------------------------------------------------------------------------------------------
select 
  * 
from
  (SELECT team , Count(medal) t_medal1
                        FROM   athletes a
                               LEFT JOIN athlete_events e
                                      ON a.id = e.athlete_id
                        WHERE  e.medal = 'silver'
                        group by team) A left join  
(select 
  *, 
  rank() over(partition by team order by t_medal desc) as rnk 
from (SELECT team ,year, Count(medal) t_medal
                        FROM   athletes a
                               LEFT JOIN athlete_events e
                                      ON a.id = e.athlete_id
                        WHERE  e.medal = 'silver'
                        group by team, year ) a ) B on A.team=B.team and rnk=1;

---------------------------------------------------------------------------------------------------------------------------------------------
--3 which player has won maximum gold medals  amongst the players which have won only gold medal (never won silver or bronze) over the years
---------------------------------------------------------------------------------------------------------------------------------------------
select 
  top 5 a.name
  , count(case when e.medal= 'gold' then e.medal end) t_medal
  , count(case when e.medal= 'silver' then e.medal end) t_medal2
  , count(case when e.medal= 'bronze' then e.medal end) t_medal3
from 
  athletes a 
left join 
  athlete_events e
ON 
  a.id = e.athlete_id
group by  
  a.name
having 
  count(case when e.medal= 'gold' then e.medal end) > 0 
  and count(case when e.medal= 'silver' then e.medal end) =0  
  and count(case when e.medal= 'bronze' then e.medal end)  =0
order by 
  t_medal desc

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--4 in each year which player has won maximum gold medal . Write a query to print year,player name and no of golds won in that year . In case of a tie print comma separated player names.
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
with cte as (
  select 
    a.name, 
    e.year, 
    count(medal) t_medal
  from 
    athletes a 
  left join 
    athlete_events e
  ON 
    a.id = e.athlete_id
  where 
    e.medal= 'gold'
  group by 
    a.name, e.year)

,cte2 as (
  select
    *,
    max(t_medal) over (partition by year) no_m_won
  from 
    cte)

select 
  year, 
  t_medal, string_agg(name, ',') as all_players 
from cte2
where 
  t_medal= no_m_won
group by 
  year, 
  t_medal 


------------------------------------------------------------------------------------------------------------------------------------------
--5 in which event and year India has won its first gold medal,first silver medal and first bronze medal print 3 columns medal,year,sport
------------------------------------------------------------------------------------------------------------------------------------------
with cte as (
  select * 
  from 
    athletes a 
  left join 
    athlete_events e
  ON 
    a.id = e.athlete_id
  where 
    team = 'india' )

, cte2 as (
  select 
    *, 
    rank() over (partition by medal order by year) rnk
  from cte)

select 
  medal,
  year, 
  string_agg(event, ',') as events_of_year 
from cte2
where 
  rnk= 1 and medal in ('gold', 'silver', 'bronze')
group by 
  medal, 
  year


------------------------------------------------------------------------
--6 find players who won gold medal in summer and winter olympics both.
------------------------------------------------------------------------
select 
  name
  , count(case when season= 'winter' then season end) t_season
  , count(case when season= 'summer' then season end) t_season2
from 
  athletes a 
left join 
  athlete_events e
ON 
  a.id = e.athlete_id
where 
  medal='gold'
group by  
  a.name
having   
  count(case when season= 'winter' then season end) > 0 
  and count(case when season= 'summer' then season end) >0 


---------------------------------------------------------------------------------------------------------------------------------------------
--7 find players who won gold, silver and bronze medal in a single olympics. print player name along with year.
---------------------------------------------------------------------------------------------------------------------------------------------
select 
  name, 
  year
  , count(case when e.medal= 'gold' then e.medal end) g_medal
  , count(case when e.medal= 'silver' then e.medal end) s_medal
  , count(case when e.medal= 'bronze' then e.medal end) b_medal
from 
  athletes a 
left join 
  athlete_events e
ON 
  a.id = e.athlete_id
group by  
  a.name, year
having 
  count(case when e.medal= 'gold' then e.medal end) >0
  and count(case when e.medal= 'silver' then e.medal end) >0
  and count(case when e.medal= 'bronze' then e.medal end) >0
  

---------------------------------------------------------------------------------------------------------------------------------------------
--8 find players who have won gold medals in consecutive 3 summer olympics in the same event .Consider only olympics 2000 onwards. 
--Assume summer olympics happens every 4 year starting 2000. print player name and event name.
---------------------------------------------------------------------------------------------------------------------------------------------
with cte as
(
  select *
  from 
    athletes a 
  left join 
    athlete_events e
  ON 
    a.id = e.athlete_id
  where 
    medal= 'gold' and season= 'summer' and year >= 2000
)

, cte2 as 
(
  select 
    name, 
    year, 
    event, 
    year - min(year) over (partition by name,event order by year rows between 2 preceding and current row) rnk2, 
    min(year) over (partition by name,event order by year rows between 2 preceding and current row) rnk22,   
    year - (min(year) over (partition by name,event order by year rows between 1 preceding and current row)) rnk3,   
    (min(year) over (partition by name,event order by year rows between 1 preceding and current row)) rnk32
  from cte
)

select 
  distinct name,
  event 
from 
  cte2 
where 
  rnk2=8 and rnk3=4

