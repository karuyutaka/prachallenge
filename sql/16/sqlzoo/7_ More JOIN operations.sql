
-- movie
-- id	title	yr	director	budget	gross 

-- actor
-- id	name

-- casting
-- movieid	actorid	ord



-- 1:1962 年の映画のリストを表示（ id と title を表示）
SELECT id, title
FROM movie
WHERE yr=1962

-- 2:'Citizen Kane'の年を示す。
SELECT yr
FROM movie
WHERE title='Citizen Kane'

-- 3:スタートレック（'Star Trek'）というシリーズ映画のリストを表示（ id title yr ）。 年の順に掲載。
SELECT id, title, yr
FROM movie
WHERE title LIKE 'Star Trek%'
ORDER BY yr ASC

-- 4:女優 'Glenn Close' 　の id ナンバーは何ですか？
SELECT id
FROM actor
WHERE name = 'Glenn Close'

-- 5:映画 'Casablanca' カサブランカの id は何ですか？
SELECT id
FROM movie
WHERE title = 'Casablanca'

-- 6:t映画カサブランカの出演リスト(name)を出力する。'Casablanca'
-- 出演リストとは?
-- その映画に出演した役者のリスト
-- movieid=11768を使う。 (または、これまでの問題で得た値を何でも使ってよい)

SELECT name
FROM movie
INNER JOIN casting ON movie.id = casting.movieid
INNER JOIN actor ON casting.actorid = actor.id
WHERE movie.title = 'Casablanca'

-- 7:映画「エイリアン」'Alien'の出演者リストを表示。
SELECT name
FROM movie
INNER JOIN casting ON movie.id = casting.movieid
INNER JOIN actor ON casting.actorid = actor.id
WHERE movie.title = 'Alien'

-- 8:'Harrison Ford'  ハリソン＝フォードが出演した映画のリストを表示する。    
SELECT title
FROM movie
INNER JOIN casting ON movie.id = casting.movieid
INNER JOIN actor ON casting.actorid = actor.id
WHERE actor.name = 'Harrison Ford' 

-- 9:Harrison Ford'ハリソン＝フォードが出演した映画で、彼が主演していない(ord <> 1） のリストを表示。
-- [Note: ord は、映画の出演リスト順、1 が主演を意味する。]
SELECT title
FROM movie
INNER JOIN casting ON movie.id = casting.movieid
INNER JOIN actor ON casting.actorid = actor.id
WHERE actor.name = 'Harrison Ford' 
AND ord <>1

-- 10:1962年の全映画を、そのタイトルと主演と併記してリスト表示。
SELECT title,name
FROM movie
INNER JOIN casting ON movie.id = casting.movieid
INNER JOIN actor ON casting.actorid = actor.id
WHERE movie.yr = 1962
AND ord = 1
