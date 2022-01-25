-- 1:ドイツ(Germany)の人口(population)を表示するように修正する。
SELECT population FROM world WHERE name = 'Germany'

-- 2:ドイツ(Germany)の人口(population)を表示するように修正する。
SELECT name, population FROM world
  WHERE name IN ('Sweden', 'Norway', 'Denmark');

-- 3:ドイツ(Germany)の人口(population)を表示するように修正する。
SELECT name, area FROM world
  WHERE area BETWEEN 200000 AND 250000