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