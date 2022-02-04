-- name 国名	continent 大陸	area 面積	population 人口	gdp 国内総生産
-- Afghanstan	Asia	652230	25500100	20343000000
-- Albania	Europe	28748	2831741	12960000000
-- Algeria	Africa	2381741	37100000	188681000000
-- Andorra	Europe	468	78115	3712000000
-- Angola	Africa	1246700	20609294	100990000000



-- 1:世界の総人口を表示。（各国の人口を合計）
SELECT SUM(population)
FROM world

-- 2:大陸名を重複しないように表示。
SELECT DISTINCT(continent)
FROM world

-- 3:アフリカAfrica の各国のgdpの合計を求める。
SELECT SUM(gdp) FROM world
WHERE continent = 'Africa'

-- 4:面積が少なくとも 1000000　以上の国の数を求める。
SELECT count(name) FROM world
WHERE area >= 1000000

-- 5:'Estonia', 'Latvia', 'Lithuania' の人口合計を求める。
SELECT sum(population) FROM world
WHERE name in ('Estonia', 'Latvia', 'Lithuania')

-- 6:各大陸continentごとに大陸名continentとそこの国の数を表示する。

SELECT continent, COUNT(name)
FROM world
GROUP BY continent

-- 7:各大陸の人口が10000000人以上の国を数え、大陸名とその数を表示する。
SELECT continent, COUNT(name)
FROM world
WHERE population >= 10000000
GROUP BY continent

-- 8:その大陸の各国の人口の合計が１00000000人以上の大陸のリストを表示する
SELECT continent
FROM world
GROUP BY continent
HAVING SUM(population) >= 100000000