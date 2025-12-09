CREATE DATABASE data;
USE data;

SELECT * FROM match_data
LIMIT 10
;

---------------------------------------------------------------------------------------------------
-- How many teams participated in the tournament, 
SELECT COUNT(DISTINCT team) as no_of_teams FROM match_data
;

---------------------------------------------------------------------------------------------------
-- Which teams participated in the tournament, 

SELECT DISTINCT team FROM match_data
;

---------------------------------------------------------------------------------------------------
-- Number of matches played by the teams :

SELECT team, count(date) as no_of_match
FROM match_data
GROUP BY (team)
ORDER BY no_of_match DESC
;

-- Which team played the highest number of matches :
SELECT team, count(date) as no_of_match
FROM match_data
GROUP BY (team)
ORDER BY no_of_match DESC
LIMIT 3
;

---------------------------------------------------------------------------------------------------
-- Which team played most of the friendly matches

SELECT count(team) as no , team,  tournament 
FROM match_data
GROUP BY tournament , team
ORDER BY team
;

SELECT count(team) as no , team,  tournament 
FROM match_data
GROUP BY tournament , team
ORDER BY tournament , no DESC
;

SELECT DISTINCT tournament 
FROM match_data
ORDER BY tournament
;


---------------------------------------------------------------------------------------------------
-- Creating a different table for FIFA world cup 

CREATE TABLE if not exists fifa_cup AS
SELECT team, away_team, tournament, team_win, city, country
FROM match_data
WHERE tournament = "FIFA World Cup"
;

SELECT * FROM fifa_cup
LIMIT 10
;

-- Where Brazil won, and against which teams 
SELECT team, away_team, team_win
FROM fifa_cup
WHERE team = "Brazil" and team_win = 1
;

---------------------------------------------------------------------------------------------------
-- The team that won most of the matches in FIFA World Cup

SELECT  count(team_win) as won_matches , team 
FROM fifa_cup 
WHERE team_win = 1
GROUP BY team 
ORDER BY won_matches DESC
;
-- Brazil won 58 fifa world cups, highest

-- In which country were the matches won by Brazil played 

SELECT team, away_team, country, city 
FROM match_data
WHERE team_win = 1 and team = "Brazil"
;



-- opimized 
SELECT team, country, count(team_win) as no
FROM fifa_cup
WHERE team_win = 1 and team = "Brazil"
GROUP BY country
ORDER BY no DESC
;
-- highest number of matches won by Brazil were played in Mexico, France, Brazil


-- Against which country did Brazil won highest number of matches and where were they played IN FIFA CUP

SELECT team, count(team_win) as won_matches, away_team, country
FROM fifa_cup
WHERE team = "Brazil" and team_win = 1
GROUP BY away_team, country
;

-- optimized (which country was defeated most of the times by Brazil)
SELECT team, count(team_win) as won_matches, away_team
FROM fifa_cup
WHERE team = "Brazil" and team_win = 1
GROUP BY away_team
ORDER BY won_matches DESC
;

-- Poland


---------------------------------------------------------------------------------------------------




---------------------------------------------------------------------------------------------------



---------------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------------



---------------------------------------------------------------------------------------------------



---------------------------------------------------------------------------------------------------



---------------------------------------------------------------------------------------------------



---------------------------------------------------------------------------------------------------



---------------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------------



---------------------------------------------------------------------------------------------------



---------------------------------------------------------------------------------------------------



---------------------------------------------------------------------------------------------------




















































































