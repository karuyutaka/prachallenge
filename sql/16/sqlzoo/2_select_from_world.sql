-- テーブル名 world

-- name:国名
-- continent:大陸
-- area:面積
-- population:人口
-- gdp:国内総生産


-- 1:全ての国の国名と大陸と人口を表示する SQL コマンドを実行して結果を観察する。
SELECT name, continent,population FROM world

-- 2:人口が２億人（200000000 ゼロが８個ある）以上の国の名前を表示
SELECT name FROM world
WHERE population >= 200000000;

-- 3:人口population２億人以上の国の国名nameと国民一人当たりの国内総生産を表示
SELECT name, gdp/population FROM world 
WHERE population >= 200000000

-- 4:大陸continentが South America の国のnameとpopulationを
-- 百万人単位に変換して表示する。人口 population を 1000000 で割ると１００万人単位の人口になる。
SELECT name, population/1000000 FROM world
WHERE continent = 'South America'

-- 5:国名nameと人口population を France, Germany, Italy について表示する。
SELECT name, population FROM world
WHERE name in ('France', 'Germany', 'Italy')

-- 6:国名に 'United'を含む国の国名を特定する。
SELECT name FROM world
WHERE name LIKE '%United%'

-- 7:ビッグになる２つの道: ビッグな国とは、面積が 3000000 平方キロ以上　または　人口が 250000000 以上の国とする。
-- 面積か人口がビッグな国を表示する。国名　人口　面積（name, population , area）を表示する。
SELECT name,population,area FROM world
WHERE area >= 3000000 or population >= 250000000;

-- 8:排他的論理和 Exclusive OR (XOR)の問題。面積か人口のどちらかだけ（両方は除く）が大きな国を表示する。国名 人口 面積を表示する(name, population, area)。
SELECT name,population,area FROM world
WHERE area >= 3000000 xor population >= 250000000;

-- 9:南アメリカ大陸にある国の国名と人口（100万人単位）とGDP（10億ドル単位）を小数点以下２桁に丸めて表示する。
SELECT name,ROUND(population/1000000,2),ROUND(gdp/1000000000,2) FROM world
WHERE continent = 'South America'

-- 10:GDPが1兆ドル以上の国の国名と国民一人当たりのGDPを1000ドル単位に丸めて表示する。
SELECT name, ROUND(gdp/population, -3) FROM world 
WHERE gdp >= 1000000000000

-- 11:国名 name と首都 capital が同じ長さの国の、国名と首都を表示する。
SELECT name, capital
FROM world
WHERE LENGTH(name) = LENGTH(capital);

-- 12:国名と首都の先頭の文字が同じである国の、国名と首都名を表示する。ただし、国名と首都名が同じ場合は除く。
SELECT name,capital FROM world
WHERE LEFT(name,1) =  LEFT(capital,1)
AND name <> capital;

-- 13:国名に全ての母音を含む国で、空白を含まない単語１つの国名を検索する。
SELECT name
FROM world
WHERE name LIKE '%a%'
AND name LIKE '%e%'
AND name LIKE '%i%'
AND name LIKE '%o%'
AND name LIKE '%u%'
AND name NOT LIKE '% %'