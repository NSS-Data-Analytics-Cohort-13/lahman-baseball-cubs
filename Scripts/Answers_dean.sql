-- 3. Find all players in the database who played at Vanderbilt University. Create a list showing each player’s first and last names as well as the total salary they earned in the major leagues. Sort this list in descending order by the total salary earned. Which Vanderbilt player earned the most money in the majors?

SELECT * FROM schools
where schoolname ilike '%vanderbilt%'; --vandy for school ID

SELECT * FROM PEOPLE; --PlyerID 
SELECT * FROM collegeplaying; --playerID + schoolID
SELECT * FROM salaries; --PlayerID    NEED salary



--People to collegeplaying (playerid) > schools (schoolid) people to salaries (playerid) >>>>

SELECT	namefirst  --getting first and last names
	,	namelast
FROM people;

SELECT salary   --getting salaries
FROM salaries;

SELECT * FROM TEAMS;
SELECT * FROM PARKS
WHERE PARK ILIKE '%vand%';

--querry time
SELECT	pep.namefirst 
	,	pep.namelast
	,	SUM(sal.salary)::INT::MONEY AS salary
FROM people AS pep
INNER JOIN salaries AS sal
	ON pep.playerid = sal.playerid
INNER JOIN collegeplaying AS coll
	ON pep.playerid = coll.playerid
INNER JOIN schools
	ON coll.schoolid = schools.schoolid
WHERE schools.schoolid = 'vandy'
GROUP BY pep.namefirst 
	,	pep.namelast
ORDER BY salary DESC;  --HOULD BE AROUND 81M

SELECT	pep.namefirst 
	,	pep.namelast
	--,	sal.salary)::INT::MONEY AS salary
FROM people AS pep
INNER JOIN salaries AS sal
	ON pep.playerid = sal.playerid
INNER JOIN collegeplaying AS coll
	ON pep.playerid = coll.playerid
INNER JOIN schools
	ON coll.schoolid = schools.schoolid
WHERE schools.schoolid = 'vandy'
--GROUP BY pep.namefirst 
--	,	pep.namelast
ORDER BY pep.namefirst,	pep.namelast DESC;



SELECT * FROM people as p
INNER JOIN  collegeplaying as c
ON p.playerid =c.playerid
INNER JOIN salaries as sa
on p.playerid = sa.playerid
WHERE p.playerid ='alvarpe01';

