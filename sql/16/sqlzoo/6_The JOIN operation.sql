
-- game
-- id	mdate	stadium	team1	team2
-- 1001	8 June 2012	National Stadium, Warsaw	POL	GRE
-- 1002	8 June 2012	Stadion Miejski (Wroclaw)	RUS	CZE
-- 1003	12 June 2012	Stadion Miejski (Wroclaw)	GRE	CZE
-- 1004	12 June 2012	National Stadium, Warsaw	POL	RUS
-- ...


-- goal
-- matchid	teamid	player	gtime
-- 1001	POL	Robert Lewandowski	17
-- 1001	GRE	Dimitris Salpingidis	51
-- 1002	RUS	Alan Dzagoev	15
-- 1002	RUS	Roman Pavlyuchenko	82
-- ...



-- eteam
-- id	teamname	coach
-- POL	Poland	Franciszek Smuda
-- RUS	Russia	Dick Advocaat
-- CZE	Czech Republic	Michal Bilek
-- GRE	Greece	Fernando Santos
-- ...



-- 1:matchid と player 名をドイツ(Germany)チームの全ゴールについて表示する。ドイツプレイヤーを識別するには、次を確認: teamid = 'GER'
SELECT matchid,player FROM goal 
WHERE teamid = 'GER'

-- 2:試合 1012 の id, stadium, team1, team2 を表示する。
select
id,stadium,team1,team2
from
game
where
id = 1012;

-- 3:ドイツの全ゴールについて player, teamid ,stadium, mdate を表示するように修正する。
SELECT player, teamid ,stadium, mdate  FROM goal
INNER join game ON goal.matchid = game.id
WHERE teamid = 'GER'

-- 4:Marioという名前の選手のゴールについて、team1, team2 , player を表示する。player LIKE 'Mario%'
SELECT team1, team2 , player  FROM goal
INNER join game ON goal.matchid = game.id
WHERE player LIKE 'Mario%'

-- 5:最初の１０分間でゴールしたという条件で、 player, teamid, coach, gtime を表示。gtime<=10
SELECT  player, teamid, coach, gtime  FROM goal
INNER join eteam ON goal.teamid = eteam.id
WHERE gtime <= 10

-- 6:team1のコーチcoachが 'Fernando Santos' となる試合日mdateとチーム名teamnameを表示。

SELECT  mdate, teamname  FROM game
INNER join eteam ON game.team1 = eteam.id
WHERE coach = 'Fernando Santos'

-- 7:'National Stadium, Warsaw' スタジアムで開催された試合でゴールした選手を表示する。
SELECT player  FROM goal
INNER join game ON goal.matchid = game.id
WHERE stadium =  'National Stadium, Warsaw'
