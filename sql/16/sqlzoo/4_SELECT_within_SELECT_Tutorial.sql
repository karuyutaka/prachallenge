-- name 国名	continent 大陸	area 面積	population 人口	gdp 国内総生産
-- Afghanistan	Asia	652230	25500100	20343000000
-- Albania	Europe	28748	2831741	12960000000
-- Algeria	Africa	2381741	37100000	188681000000
-- Andorra	Europe	468	78115	3712000000
-- Angola	Africa	1246700	20609294	100990000000



-- 1:ロシア（Russia）よりも人口(population)が多い国の名前を表示する
SELECT name FROM world
WHERE population > (SELECT population FROM world WHERE name = 'Russia')

-- 2:国民一人当たりの国内総生産がイギリス 'United Kingdom' よりも大きなヨーロッパの国を表示する。
SELECT name FROM world
WHERE gdp/population > (SELECT gdp/population FROM world WHERE name = 'United Kingdom')
AND continent = 'Europe'

-- 3:'Argentina'または'Australia'を含む大陸にある国の、国名と大陸を表示する。国名順に表示する。
SELECT name,continent FROM world
WHERE continent in (SELECT continent FROM world WHERE name = 'Argentina' or name = 'Australia')
ORDER BY name

-- 4:人口がカナダ Canadaよりも多く、ポーランドPolandよりも少ない国の、国名と人口を表示する。
SELECT name,population FROM world
WHERE population > (SELECT population FROM world WHERE name =  'Canada' )
AND population < (SELECT population FROM world WHERE name =  'Poland' )

-- 5:ヨーロッパの各国について 国名と人口を表示する。ドイツ人口の何％かで表示する。
select
name, concat(round(population/(select population from world where name = 'Germany')*100,0),'%') 
from 
world
where
continent = 'Europe';

-- 6:ヨーロッパのどの国のGDPよりも大きなGDPを持つ国の国名だけを表示する。（GDPがNULL の国も有る）

SELECT name FROM world
WHERE gdp > ALL(SELECT max(gdp) FROM world where continent = 'Europe')

-- 7:各大陸のもっとも大きな国（面積で）の大陸、国名、面積を表示する。
SELECT continent, name, area FROM world x
  WHERE area >= ALL
    (SELECT area FROM world y
        WHERE y.continent=x.continent)

-- 8:各大陸の中でアルファベット順で先頭になる国の大陸と国名を表示する。
select
continent, min(name) 
from
world
group by
continent;

-- 9:大陸に属する各国の人口が25000000以下である大陸を見つけ、それらの大陸に属する国の名前と大陸と人口を表示。
SELECT name ,continent ,population
FROM world X
WHERE 25000000 >= ALL(SELECT population FROM world Y where Y.continent = X.continent)


-- 10:同じ大陸にある他の全ての国よりも３倍は大きな人口の国の、国名と大陸を表示する。
select
 name, continent 
from
 world A
where
 population>all(select 3*population
               from world B
               where B.continent= A.continent
                and B.name <> A.name);