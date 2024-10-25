--1. What range of years for baseball games played does the provided database cover? 
SELECT MIN (year) AS first_year,
		MAX (year) AS last_year
FROM homegames;
--2. Find the name and height of the shortest player in the database. How many games did he play in? What is the name of the team for which he played?
SELECT people.namefirst, people.namelast, COUNT(allstar.gameid) AS appearances, allstar.teamid, people.height
FROM people AS people
FULL JOIN allstarfull AS allstar
ON people.playerid = allstar.playerid
FULL JOIN managershalf as manager
ON people.playerid=manager.playerid
WHERE people.namefirst = 'Eddie' AND people.namelast='Gaedel'
GROUP BY people.namefirst, people.namelast, allstar.teamid, people.height;
--3. Find all players in the database who played at Vanderbilt University. Create a list showing each player’s first and last names as well as the total salary they earned in the major leagues. Sort this list in descending order by the total salary earned. Which Vanderbilt player earned the most money in the majors?
--First Attempt (Need to update)
SELECT college.schoolid,
		people.namefirst, 
		people.namelast, 
		schools.schoolname
FROM schools
INNER JOIN collegeplaying AS college
ON schools.schoolid=college.schoolid
INNER JOIN people
ON college.playerid=people.playerID
ORDER BY schools.schoolname 
WHERE schools.schoolname iLike 'Vanderbilt';

--Dean Attempt
SELECT pep.namefirst,
		pep.namelast,
		SUM (sal.salary) ::INT::MONEY AS salary
FROM people AS pep
INNER JOIN salaries AS sal
	ON pep.playerid=sal.playerid
INNER JOIN (
			SELECT DISTINCT (collegeplaying.schoolid),
			playerid
			FROM collegeplaying
			INNER JOIN schools
			ON collegeplaying.schoolid=schools.schoolid) 
			AS school
ON pep.playerid=school.playerid
WHERE school.schoolid ='vandy'
GROUP BY pep.namefirst,
		pep.namelast
ORDER BY pep.namefirst, pep.namelast DESC;

--4. Using the fielding table, group players into three groups based on their position: label players with position OF as "Outfield", those with position "SS", "1B", "2B", and "3B" as "Infield", and those with position "P" or "C" as "Battery". Determine the number of putouts made by each of these three groups in 2016.
--5. Find the average number of strikeouts per game by decade since 1920. Round the numbers you report to 2 decimal places. Do the same for home runs per game. Do you see any trends?
   