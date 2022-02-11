-- 1 1996 年に 3 回以上注文した（Orders が 3 つ以上紐づいている）Customer の ID と、注文回数を取得する。最もよく注文してくれた Customer は？
SELECT CustomerID,count(OrderID) as OrderCount FROM Orders
WHERE OrderDate Like '1996%'
Group By CustomerID
having OrderCount >= 3
order by OrderCount desc

-- 最もよく注文してくれたのは、どのCustomerでしょうか？ 65,63,20

-- 2「一度の注文で、最大どれぐらいの注文詳細が紐づく可能性があるのか」調べる必要が生じました。
-- 過去最も多くのOrderDetailが紐づいたOrderを取得してください。何個OrderDetailが紐づいていたでしょうか？

SELECT OrderID,MAX(OrderDetailCount) as OrderDetailCount 
FROM ( SELECT Orders.OrderID ,count(OrderDetails.OrderID) as OrderDetailCount 
FROM Orders INNER JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID GROUP BY OrderDetails.OrderID)

-- with句で記載
WITH OrderDetailCount AS (
  SELECT OrderDetails.OrderID AS OrderID ,count(OrderDetails.OrderID) as OrderDetailCount 
FROM OrderDetails GROUP BY OrderDetails.OrderID
)

SELECT OrderID,MAX(OrderDetailCount) as OrderDetailCount from OrderDetailCount

-- 5件


-- 3「一番お世話になっている運送会社を教えて欲しい」と頼まれました。過去最も多くのOrderが紐づいたShipperを特定してみてください
SELECT Shippers.ShipperID as ShipperID   ,count(Orders.OrderId) as ShippintCount FROM Orders
INNER JOIN Shippers ON Shippers.ShipperID = Orders.ShipperID
GROUP BY Shippers.ShipperID
Order by ShippintCount desc

-- A: ShipperIDが2

-- 4.「重要な市場を把握したい」と頼まれました。売上が高い順番にCountryを並べてみましょう
-- ヒント：注文を行ったCustomerのCountryを集計すると良いでしょう
-- 売上の定義：
-- Orderごとの売上の定義は「OrderDetailsのQuantity（個数）」x「ProductsのPrice（単価）」
-- （補足：事前テストでも出題した問題です！）

with sales as (SELECT OrderDetails.Quantity * Products.Price as sales ,OrderDetails.OrderID as OrderID FROM OrderDetails
INNER JOIN Products ON Products.ProductID = OrderDetails.ProductID)

,temp_ORDER as (SELECT sales ,Orders.CustomerID as CustomerID, OrderDate FROM sales
INNER JOIN Orders ON sales.OrderID = Orders.OrderID)

,temp_country as (SELECT sales  ,Country,OrderDate  FROM temp_ORDER
INNER JOIN Customers ON temp_ORDER.CustomerID = Customers.CustomerID)

select ROUND(sum(sales))as sales,Country,strftime('%Y', OrderDate) as OrderYear from temp_country
GROUP by Country,OrderYear
ORDER by sales desc

-- 5 国ごとの売上を年毎に（1月1日~12月31日の間隔で）集計してください
-- ヒント：Web SQLで「年だけ」を取得するためにはstrftimeを使うと良いでしょう！
with sales as (SELECT OrderDetails.Quantity * Products.Price as sales ,OrderDetails.OrderID as OrderID FROM OrderDetails
INNER JOIN Products ON Products.ProductID = OrderDetails.ProductID)

,temp_ORDER as (SELECT sales ,Orders.CustomerID as CustomerID, OrderDate FROM sales
INNER JOIN Orders ON sales.OrderID = Orders.OrderID)

,temp_country as (SELECT sales  ,Country,OrderDate  FROM temp_ORDER
INNER JOIN Customers ON temp_ORDER.CustomerID = Customers.CustomerID)

select ROUND(sum(sales))as sales,Country,strftime('%Y', OrderDate) as OrderYear from temp_country
GROUP by Country,OrderYear
ORDER by sales desc


-- 6「社内の福利厚生の規定が変わったので、年齢が一定以下の社員には、それとわかるようにフラグを立てて欲しい」と頼まれました
-- Employeeテーブルに「Junior（若手）」カラム（boolean）を追加して、若手に分類されるEmployeeレコードの場合はtrueにしてください
-- Juniorの定義：誕生日が1960年より後のEmployeeの場合は値をTRUEにする更新クエリを作成してください
ALTER TABLE Employee
ADD Junior Boolean DEFAULT false NOT NULL;
UPDATE Employees SET Junior = 1 WHERE BirthDate > '1960-01-01';


-- 7「長くお世話になった運送会社には運送コストを多く払うことになったので、たくさん運送をお願いしている業者を特定して欲しい」と頼まれました
-- 「long_relation」カラム（boolean）をShipperテーブルに追加してください
-- long_relationがtrueになるべきShipperレコードを特定して、long_relationをtrueにしてください
-- long_relationの定義：これまでに70回以上、Orderに関わったShipper（つまり発注を受けて運搬作業を実施した運送会社）
ALTER TABLE Shippers
ADD long_relation Boolean DEFAULT false NOT NULL;

UPDATE Shippers SET long_relation = 1 WHERE ShipperID =
(SELECT Orders.ShipperID  FROM Orders
GROUP by Orders.ShipperID
HAVING COUNT(Orders.ShipperID) >= 70)

-- 8「それぞれのEmployeeが最後に担当したOrderと、その日付を取得してほしい」と頼まれました
-- OrderID, EmployeeID, 最も新しいOrderDate
-- 上記のような情報が得られるクエリを描いてください
-- ヒント：何らかのaggregate function（集約関数）を使う必要があるでしょう
SELECT EmployeeID,MAX(OrderDate) AS LatestOrderDate
FROM Orders
GROUP by EmployeeID

-- 9 Customerテーブルで任意の１レコードのCustomerNameをNULLにしてください
UPDATE Customers SET CustomerName = null WHERE CustomerID = 1;
-- CustomerNameが存在するユーザを取得するクエリを作成してください
SELECT * FROM Customers WHERE CustomerName IS NOT NULL
-- CustomerNameが存在しない（NULLの）ユーザを取得するクエリを変えてください
SELECT * FROM Customers WHERE CustomerName IS NULL
-- もしかすると、CustomerNameが存在しないユーザーを取得するクエリを、このように書いた方がいるかもしれません
-- SELECT * FROM Customers WHERE CustomerName = NULL;
-- しかし残念ながら、これでは期待した結果は得られません。なぜでしょうか？
IS NULLにしないと正しい結果は得られないから

-- 10 JOINの違いに慣れておきましょう！
-- EmployeeId=1の従業員のレコードを、Employeeテーブルから削除してください
Delete FROM Employees WHERE EmployeeId=1
-- OrdersとEmployeesをJOINして、注文と担当者を取得してください。その際：
-- （削除された）EmloyeeId=1が担当したOrdersを表示しないクエリを書いてください
SELECT
  O.OrderID
  , O.CustomerID
  , O.EmployeeID
  , O.OrderDate
  , O.ShipperID
FROM
  Orders AS O
    INNER JOIN Employees AS E
      ON O.EmployeeID = E.EmployeeID;
-- （削除された）EmloyeeId=1が担当したOrdersを表示する（Employeesに関する情報はNULLで埋まる）クエリを書いてください
SELECT
  O.OrderID
  , O.CustomerID
  , E.EmployeeID
  , O.OrderDate
  , O.ShipperID
FROM
  Orders AS O
    LEFT JOIN Employees AS E
      ON O.EmployeeID = E.EmployeeID
WHERE
  E.EmployeeID IS NULL;


