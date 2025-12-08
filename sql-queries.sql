CREATE DATABASE data;
USE data;

SELECT * FROM match_data;

---------------------------------------------------------------------------------------------------
-- How many teams participated in the tournament, 
SELECT COUNT(DISTINCT team) as no_of_teams FROM match_data
;

---------------------------------------------------------------------------------------------------
-- Which teams participated in the tournament, 

SELECT DISTINCT team FROM match_data
;



