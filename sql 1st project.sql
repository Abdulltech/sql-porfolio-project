
-- How many olympics have been held?

select count(distinct games) as Total_Olympic_Games
    from olympics_history;
	
	-- List down all olympics games held so far
	select distinct year,season,city  
	from olympics_history order by year;
	
	-- Mention the total no of nations who participated in each olympic games
	with all_countries as
(select oh.games, nr.region
from olympics_history oh
join olympics_history_noc_regions nr ON nr.noc = oh.noc
group by games, nr.region)
select games, count(region) as total_countries
from all_countries
group by games
order by games;


--Identify the sport which was played in all summer olympics.
      with t1 as
          	(select count(distinct games) as total_games
          	from olympics_history where season = 'Summer'),
          t2 as
          	(select distinct games, sport
          	from olympics_history where season = 'Summer'),
          t3 as
          	(select sport, count(1) as no_of_games
          	from t2
          	group by sport)
      select *
      from t3
      join t1 on t1.total_games = t3.no_of_games;
	  
	  
	-- Which Sports were just played only once in the olympics.
      with t1 as
          	(select distinct games, sport
          	from olympics_history),
          t2 as
          	(select sport, count(1) as no_of_games
          	from t1
          	group by sport)
      select t2.*, t1.games
      from t2
      join t1 on t1.sport = t2.sport
      where t2.no_of_games = 1
      order by t1.sport; 
	  
	  
	 -- Find the Ratio of male and female athletes participated in all olympic games.
    with t1 as
        	(select sex, count(1) as cnt
        	from olympics_history
        	group by sex),
        t2 as
        	(select *, row_number() over(order by cnt) as rn
        	 from t1),
        min_cnt as
        	(select cnt from t2	where rn = 1),
        max_cnt as
        	(select cnt from t2	where rn = 2)
    select concat('1 : ', round(max_cnt.cnt::decimal/min_cnt.cnt, 2)) as ratio
    from min_cnt, max_cnt;
	
	
	
	-- Top 5 most successful countries in olympics. Success is defined by no of medals won.
    with t1 as
            (select nr.region, count(1) as total_medals
            from olympics_history oh
            join olympics_history_noc_regions nr on nr.noc = oh.noc
            where medal <> 'NA'
            group by nr.region
            order by total_medals desc),
        t2 as
            (select *, dense_rank() over(order by total_medals desc) as rnk
            from t1)
    select *
    from t2
    where rnk <= 5;
	
	
	
	-- In which Sport/event, India has won highest medals.
    with t1 as
        	(select sport, count(1) as total_medals
        	from olympics_history
        	where medal <> 'NA'
        	and team = 'India'
        	group by sport
        	order by total_medals desc),
        t2 as
        	(select *, rank() over(order by total_medals desc) as rnk
        	from t1)
    select sport, total_medals
    from t2
    where rnk = 1;
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  





	