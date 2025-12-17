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
-- former_names analysis
SELECT * FROM former_names
;


-- how many teams still use the same names
SELECT current_name as same_name 
FROM former_names
WHERE current_name=former
;

SELECT count(DISTINCT current_name)
FROM former_names
;
-- 27 teams changed their names

---------------------------------------------------------------------------------------------------
-- goalscorers analysis

SELECT * FROM goalscorers
;

SELECT DISTINCT team 
FROM goalscorers
;

-- how many scorer had scored goal with penalty and how many had with their own goal
SELECT scorer, team, home_team, away_team, penalty
FROM goalscorers
WHERE penalty >= 1
ORDER BY scorer
;

-- how many scorers scored with penalty
SELECT count(scorer) as count
FROM goalscorers
WHERE penalty >= 1
;
-- 2973

-- how many scorers scored with their own goal
SELECT count(scorer) as count
FROM goalscorers
WHERE own_goal >= 1
; 
-- 823


-- Total number of goalscorers
SELECT count(scorer) as total_count
FROM goalscorers 
;
-- 44191


-- how many goals did Ronaldo/Messi score with penalty or their own goal individual 

-- penalty goals
SELECT scorer , count(penalty) as penalty_goals
FROM goalscorers
WHERE (scorer = "Cristiano Ronaldo" or scorer = "Lionel Messi") and (penalty >= 1) 
GROUP BY scorer	
ORDER BY scorer
;

-- own goals
SELECT scorer , count(own_goal) as own_goals
FROM goalscorers
WHERE (scorer = "Cristiano Ronaldo" or scorer = "Lionel Messi") and (own_goal >= 1) 
GROUP BY scorer	
ORDER BY scorer
;


-- Optimized query 
SELECT 
    scorer,
    SUM(CASE WHEN own_goal = 1 THEN 1 ELSE 0 END) AS own_goals, 
    SUM(CASE WHEN penalty = 1 THEN 1 ELSE 0 END) AS penalty_goals
FROM goalscorers
WHERE scorer IN ('Cristiano Ronaldo', 'Lionel Messi')
GROUP BY scorer
ORDER BY scorer 
;


---------------------------------------------------------------------------------------------------
-- Shootouts analysis
SELECT * FROM shootouts
;


-- how many of the winners in shootout belonged to the home_team
SELECT home_team, away_team, winner
FROM shootouts 
WHERE home_team = winner 
ORDER BY winner
;

-- No of teams where home_team won the toss
SELECT count(winner) as count
FROM shootouts 
WHERE home_team=winner
;
-- 349

-- No of teams where away_team won the toss
SELECT count(winner) as count
FROM shootouts 
WHERE winner=away_team
;
-- 303

-- The total of teams where home_team won or away_team won must be 653, but it is only 652;
SELECT *
FROM shootouts
WHERE (winner != home_team AND winner != away_team)
;
-- it is the spellings and the winner is the home_team, and also the first shooter

-- Which teams won the match with them being the first shooter
SELECT home_team, away_team, winner, first_shooter 
FROM shootouts
WHERE first_shooter=winner
;
-- most of the teams who won, were they first_shooters or not ?
-- Won matches as first shooters
SELECT count(winner) as cnt
FROM shootouts
WHERE winner=first_shooter
;
-- 322

-- Lost matches with them being first_shooters
SELECT count(winner) as cnt
FROM shootouts 
WHERE winner!=first_shooter
;
-- 331

-- opitmized 
SELECT home_team, away_team, winner, first_shooter
FROM shootouts
WHERE home_team=winner and winner=first_shooter
;

SELECT count(winner) as team_no
FROM shootouts
WHERE home_team=winner and winner=first_shooter
;
-- 185

---------------------------------------------------------------------------------------------------
-- Adding a primary key to match_data table

ALTER TABLE match_data
ADD COLUMN id INT AUTO_INCREMENT PRIMARY KEY FIRST
;

SELECT * FROM match_data
;

-- JOINING TABLES
SELECT m.date, m.home_team, m.away_team, s.winner, g.scorer
FROM match_data as m
INNER JOIN goalscorers as g
	ON m.date=g.date
INNER JOIN shootouts as s
	ON m.date=s.date
;


---------------------------------------------------------------------------------------------------



---------------------------------------------------------------------------------------------------



---------------------------------------------------------------------------------------------------



---------------------------------------------------------------------------------------------------



---------------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------------



---------------------------------------------------------------------------------------------------



---------------------------------------------------------------------------------------------------



---------------------------------------------------------------------------------------------------




















































































