-- テーブル名 nobel

-- nobel(yr, subject, winner)


-- 1:1950年度のノーベル賞受賞者を表示するようにクエリーを修正する。
SELECT yr, subject, winner FROM nobel
WHERE yr = 1950;

-- 2:ノーベル文学賞（Literature）を1962年に受賞した人を表示
SELECT winner FROM nobel
WHERE yr = 1962
AND subject = 'Literature';

-- 3:アルバート・アインシュタイン(Albert Einstein)がノーベル賞を受賞した年と分野を表示
SELECT yr,subject FROM nobel
WHERE winner = 'Albert Einstein'

-- 4:ノーベル平和賞( subject が Peace ）の　２０００年以降（２０００を含む）の受賞者名を表示
SELECT winner FROM nobel
WHERE subject = 'Peace'
AND yr >= 2000;

-- 5:1980から1989年の間のノーベル文学賞について、年度、分野、受賞者の全ての詳細を表示する。
SELECT yr,subject, winner FROM nobel
WHERE yr BETWEEN 1980 AND 1989
AND subject = 'Literature';

-- 6:次の大統領の受賞内容の詳細を表示する。

-- テオドール＝ルーズベルト　Theodore Roosevelt
-- ウッドロウ＝ウィルソン　Woodrow Wilson
-- ジミー＝カーター　Jimmy Carter
-- バラク＝オバマ　Barack Obama

SELECT * FROM nobel
WHERE winner IN ('Theodore Roosevelt','Woodrow Wilson','Jimmy Carter','Barack Obama')

-- 7:ファーストネームが John の受賞者を表示
SELECT winner FROM nobel
WHERE winner like 'John%'

-- 8:1980年のノーベル物理賞 physics の受賞者　と　1984年の化学賞 chemistry の受賞者を共に表示する
SELECT * FROM nobel
WHERE (subject = 'physics' AND yr = 1980)
OR (subject = 'chemistry' AND yr = 1984)

-- 9:1980年の　化学 Chemistry と医学 Medicine 以外で、賞の年度、分野、名前を表示
SELECT * FROM nobel
WHERE yr = 1980
AND subject not in ('chemistry','Medicine')

-- 10:1910年以前（1910は含まず）の　初期の医学 Medicine の受賞者　と 2004年以降（2004は含む）の　最近の文学 Literature の受賞者　を共に表示する。
SELECT * FROM nobel
WHERE (subject = 'Medicine' AND yr < 1910)
OR (subject = 'Literature' AND yr >= 2004)