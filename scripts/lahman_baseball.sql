--5. Find the average number of strikeouts per game by decade since 1920. Round the numbers you report to 2 decimal places. Do the same for home runs per game. Do you see any trends?

SELECT *
FROM batting

SELECT g
FROM batting

SELECT yearid
FROM batting
WHERE yearid >= '1920'

SELECT AVG(so)
FROM batting

SELECT AVG(hr)
FROM batting

--SELECT yearid, g AS games, AVG(so) AS avg_strikeouts
--FROM (
   -- SELECT g, yearid, so
   -- FROM batting
	--WHERE yearid >= 1920
--) AS decade
--GROUP BY yearid;

--SELECT yearid, AVG(so) AS avg_strikeouts
--FROM (
   -- SELECT g, yearid, so
   -- FROM batting
   -- WHERE yearid >= 1920
--) AS decade
--GROUP BY yearid;

--SELECT yearid, g AS games, AVG(so) AS avg_strikeouts
--FROM (
    --SELECT g, yearid, so
    --FROM batting
    --WHERE yearid >= 1920
--) AS decade
--GROUP BY yearid;

--SELECT yearid, g
--, (
 --SELECT AVG(so) 
 --FROM batting 
 --WHERE yearid = b.yearid
-- ) AS avg_strikeouts
--FROM batting AS b
--WHERE yearid >= 1920;

--WITH game_data AS (
  --  SELECT g, yearid, so
   -- FROM batting
   -- WHERE yearid >= 1920
--)
--SELECT yearid, g, AVG(so) OVER (PARTITION BY yearid) AS avg_strikeouts
--FROM game_data;


--WITH game_data AS (
--    SELECT 
--        g, 
--        yearid, 
--        so,
--        (yearid / 10) * 10 AS decade  -- Extracting the decade
--    FROM batting
--    WHERE yearid >= 1920
--)
--SELECT 
--    decade, 
 --   g, 
  --  AVG(so) OVER (PARTITION BY decade) AS avg_strikeouts
--FROM game_data
--ORDER BY decade, g;

WITH game_data AS (
    SELECT 
        g, 
        yearid, 
        so,
        hr,  -- Include home runs
        (yearid / 10) * 10 AS decade  -- Extracting the decade
    FROM batting
    WHERE yearid >= 1920
)
SELECT 
    decade, 
    ROUND(AVG(so), 2) AS avg_strikeouts,  -- Rounding average strikeouts to 2 decimal places
    ROUND(AVG(hr), 2) AS avg_home_runs  -- Rounding average home runs to 2 decimal places
FROM game_data
GROUP BY decade  -- Group by decade
ORDER BY decade;  -- Order results by decade

