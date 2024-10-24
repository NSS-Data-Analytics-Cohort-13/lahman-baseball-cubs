Select *
FROM public.people
ORDER BY height ASC; --Query that shows the height and name of the shortest player

SELECT *
FROM public.allstarfull;


SELECT *
FROM public.homegames


SELECT people.namefirst, people.namelast, COUNT(allstar.gameid) AS appearances, allstar.teamid
FROM public.people AS people
FULL JOIN allstarfull AS allstar
ON people.playerid = allstar.playerid
FULL JOIN teams
ON 
WHERE people.namefirst = 'Eddie' AND people.namelast='Gaedel'
GROUP BY people.namefirst, people.namelast, allstar.teamid;