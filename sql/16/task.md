課題２
GROUP BYした上で絞り込みを行う際「WHERE」と「HAVING」二つのクエリを使えますが、
それぞれの違いを教えてください。どのような時にどちらを使うべきでしょうか？  

Where句はselect句の結果からwhere句で指定した抽出条件を実行する
Having句はGroupBy句でグルーピングした結果からHaving句で指定した抽出条件を実行する

SQLが実行される順序は以下のようになっており

FROM → WHERE → GROUPBY → HAVING → SELECT → ORDERBY
GroupByでグルーピングする前に抽出するのがWhere句で
GroupByでグルーピングした後に抽出するのがHaving句になります。

WHERE・・・グループ化をされる前の段階、つまり元々のデータでの抽出条件を指定できる
HAVING・・・グループ化した後の情報での、抽出条件を指定できる。

SQLの文脈においてDDL、DML、DCL、TCLとは何でしょうか？それぞれ説明してください

DDL Data Definition Language データを定義するSQL create文
DML Data Manipulation Language データを操作するSQL selectなど
DCL Data Control Language データを制御するSQL grantなど
TCL Transaction Control Language トランザクションを制御する命令になる。


課題３
inner joinとouter joinの違いはなんでしょうか？説明してください。