-- 1:Y で始まる国名を見つける
SELECT name FROM world
  WHERE name LIKE 'Y%'

-- 2:y で終わる国名を見つける
SELECT name FROM world
  WHERE name LIKE '%y'

-- 3:x を含む国名を見つける
SELECT name FROM world
  WHERE name LIKE '%x%'

-- 4:land で終わる国名を検索する。
SELECT name FROM world
  WHERE name LIKE '%land'

-- 5:C で始まり ia で終わる国を見つける
SELECT name FROM world
  WHERE name LIKE 'C%' and name Like '%ia'

-- 6:oo を名前に含む国を見つける
SELECT name FROM world
  WHERE name LIKE '%oo%'

-- 7:a を３つ以上含む国名を見つける
SELECT name FROM world
  WHERE name LIKE '%a%a%a%'

-- 8:"t" を第２文字目に持つ国名を見つける
SELECT name FROM world
 WHERE name LIKE '_t%'
ORDER BY name

-- 9:複数の"o"が他の２文字で隔てられている国名を見つける
SELECT name FROM world
 WHERE name LIKE '%o__o%'

-- 10:ちょうど４文字の国名を見つける
SELECT name FROM world
 WHERE name LIKE '____'