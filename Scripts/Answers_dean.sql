--1. What range of years for baseball games played does the provided database cover? 
--1st attempt (assuming failed attempt)
SELECT DISTINCT(yearid)
FROM
collegeplaying
WHERE yearid BETWEEN	(
						SELECT	MIN(yearid) as year
						FROM collegeplaying
						) 
					AND 
						(
						SELECT	MAX(yearid) as year
						FROM collegeplaying
						)
ORDER BY yearid ASC;

--2nd attempt (assuming failed attempt)
SELECT	MIN(yearid) as first_year
	,	MAX(yearid) as last_year
FROM collegeplaying;

--3rd attempt (assuming good attempt)
SELECT	MIN(span_first) AS first_year
	,	max(span_last) as last_year 
FROM homegames;


-- 2. Find the name and height of the shortest player in the database. How many games did he play in? What is the name of the team for which he played?
--starting point
SELECT * FROM people;
--building up on that point
SELECT namegiven, height FROM people;
--finding player with shortest height along with his playerid for next part of question
SELECT playerid,namegiven, MIN(height) AS height FROM people GROUP BY namegiven, playerid ORDER BY height ASC LIMIT 1;

--doublechecking to make sure games played are good
SELECT teamid, yearid, playerid FROM appearances
WHERE playerid = 'gaedeed01';--'alvarpe01' this is to check multiple games (SLA to be team id for player with shortest height)

--working on sub querry
SELECT	distinct(ap.playerid)
	,	 t.name
FROM appearances AS ap
	INNER JOIN teams as t
ON t.teamid = ap.teamid
where ap.playerid = 'gaedeed01'

--1st attempt 
SELECT	pep.namegiven
	,	MIN(pep.height) AS height
	,	t.name
FROM people AS pep
INNER JOIN (
			SELECT	distinct(ap.playerid)
				,	 t.name
			FROM appearances AS ap
			INNER JOIN teams as t
				ON t.teamid = ap.teamid
			) AS t
ON pep.playerid = t.playerid
WHERE t.playerid = 'gaedeed01'
GROUP BY pep.namegiven ,t.name;

--3rd attempt (final assumed good attempt)

SELECT	p.namegiven
	,	MIN(p.height) AS height
	,	a.g_all AS GamesPlayed
	,	t.name AS TeamName
FROM people p 
JOIN appearances a 
	ON p.playerid = a.playerid
JOIN teams t 
	ON a.teamid = t.teamid
WHERE p.playerid = 'gaedeed01'
GROUP BY p.namegiven, a.g_all, t.name;


-- 3. Find all players in the database who played at Vanderbilt University. Create a list showing each player’s first and last names as well as the total salary they earned in the major leagues. Sort this list in descending order by the total salary earned. Which Vanderbilt player earned the most money in the majors?

SELECT * FROM schools
where schoolname ilike '%vanderbilt%'; --finding schoolid for Vanderbilt University 

SELECT * FROM PEOPLE; --PlyerID 
SELECT * FROM collegeplaying; --playerID + schoolID
SELECT * FROM salaries; --PlayerID    NEED salary from this table


--first attempt (failed)
SELECT	pep.namefirst 
	,	pep.namelast
	,	SUM(sal.salary)::INT::MONEY AS salary
FROM people AS pep
INNER JOIN salaries AS sal
	ON pep.playerid = sal.playerid
INNER JOIN collegeplaying AS coll --ended up giving duplicates
	ON pep.playerid = coll.playerid
INNER JOIN schools
	ON coll.schoolid = schools.schoolid
WHERE schools.schoolid = 'vandy'
GROUP BY pep.namefirst 
	,	pep.namelast
ORDER BY salary DESC;  


--Finding duplicates...
SELECT * 
FROM people as p
INNER JOIN  collegeplaying as c
	ON p.playerid =c.playerid
INNER JOIN salaries as sa
	on p.playerid = sa.playerid
WHERE p.playerid ='alvarpe01';

--Fixing duplicates.....
SELECT distinct(collegeplaying.schoolid)
,	playerid
FROM collegeplaying
INNER JOIN schools
ON collegeplaying.schoolid = schools.schoolid;
SELECT * FROM salaries;


--2nd attempt with sub queries to produce unique values between Collegeplaying and Schools to remove duplicates
SELECT	pep.namefirst 
	,	pep.namelast
	,	SUM(sal.salary)::INT::MONEY AS salary
FROM people AS pep
INNER JOIN salaries AS sal
	ON pep.playerid = sal.playerid
INNER JOIN (
			SELECT distinct(collegeplaying.schoolid)
			,	playerid
			FROM collegeplaying
			INNER JOIN schools
			ON collegeplaying.schoolid = schools.schoolid
			) AS school
ON pep.playerid = school.playerid
WHERE school.schoolid = 'vandy'
GROUP BY pep.namefirst 
	,	pep.namelast
ORDER BY pep.namefirst,	pep.namelast DESC;



-- 4. Using the fielding table, group players into three groups based on their position: label players with position OF as "Outfield", those with position "SS", "1B", "2B", and "3B" as "Infield", and those with position "P" or "C" as "Battery". Determine the number of putouts made by each of these three groups in 2016.

--1st attempt (assumed good attempt)
SELECT CASE WHEN f.Pos = 'OF' THEN 'Outfield'
			WHEN f.Pos = 'SS' or f.Pos = '1B' or f.Pos = '2B' or f.Pos = '3B' THEN 'Infeild'
			WHEN f.Pos = 'P' or f.Pos = 'C' THEN 'Battery'
		END as Positions
	,	COUNT(f.Pos)
FROM fielding f 
join homegames h 
	on f.yearid = h.year
WHERE extract(year from h.span_first) = '2016'
GROUP BY positions
		-- Not sure why case statement isn't working in the GROUP BY field but Alias(positions) works fine
			-- GROUP BY CASE WHEN f.Pos = 'OF' THEN 'Outfield'
			-- WHEN f.Pos = 'SS' or f.Pos = '1B' or f.Pos = '2B' or f.Pos = '3B' THEN 'Infeild'
			-- WHEN f.Pos = 'P' or f.Pos = 'C' THEN 'Battery'
			-- END
   

-- 5. Find the average number of strikeouts per game by decade since 1920. Round the numbers you report to 2 decimal places. Do the same for home runs per game. Do you see any trends?


