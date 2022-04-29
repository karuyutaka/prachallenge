- インデックスの仕組みを、プログラミング歴1ヶ月のエンジニアにも伝わるよう、わかりやすく説明してください
    - テーブルのある行へのアクセスを集合住宅での荷物の配達に例えると、インデックスの有無は以下のように表現することができます。
        - インデックス無がない場合集合住宅を歩き回り、各戸の表札を見て配達先かどうか確かめる
        - インデックス有住民の情報が書かれた見取り図で配達先を確認して向かう

- slow query logを調べる必要があるのはなぜ？
  - SQLの実行時間を指定した時間よりもかかってしまったSQLを出力することで本番運用時のパフォーマンスのボトルネックとなっているSQLを発見するのにつながるから。

- インデックスを貼るべきか検討する際に「カーディナリティ」という数値を活用することもあります。カーディナリティとは何でしょうか？
  - テーブルのカラムに格納されているデータの種類がどのくらいあるのかをカーディナリティという。カーディナリティが低い例としては性別、男と女の二種類である。逆に高い例は顧客番号である。

- カバリングインデックスを説明する。
  - データが欲しい時に、より小さなコストでやろうと思ったら、
行全体を取得するよりも、インデックスのみで処理するようが良いに決まっている。そこで、クエリを処理するのに必要なデータを全て含んでいるようなインデックスをカバリングインデックスと呼ぶ。
  - クエリが必要とするカラムがすべてインデックスに含まれている場合、インデックスだけを読めば良いのでとても速い
  
  参考サイト　https://blog.kyanny.me/entry/20100920/1284992435

- autoincrementのメリットデメリット
  - メリット
    - パフォーマンス的に有利
    - 番号なので読みやすい
  - デメリット
    - idが連番なのでスクレイピングされやすい
    - 連番なので攻撃がしやすい
    - 複数DBを使用していた場合双方のDBで衝突する可能性がある
    - insertするまでidがわからない

- 2 課題
  - docker使い方
  ``` docker run -d \
  --name mysql-employees \
  -p 3306:3306 \
  -e MYSQL_ROOT_PASSWORD=college \
  -v $PWD/data:/var/lib/mysql \
  genschsa/mysql-employees 
  ```
  docker ps
  docker exec -i -t mysql-employees bash

  mysql -u root -p
  college
  SHOW DATABASES;
  USE employees;

  SELECT * FROM employees WHERE last_name like "b%";

- 実行速度計測(実行前)
  - explain SELECT * FROM employees WHERE last_name like "b%";
  ```
  +----+-------------+-----------+------------+------+---------------+------+---------+------+--------+----------+-------------+
| id | select_type | table     | partitions | type | possible_keys | key  | key_len | ref  | rows   | filtered | Extra       |
+----+-------------+-----------+------------+------+---------------+------+---------+------+--------+----------+-------------+
|  1 | SIMPLE      | employees | NULL       | ALL  | NULL          | NULL | NULL    | NULL | 299113 |    11.11 | Using where |
+----+-------------+-----------+------------+------+---------------+------+---------+------+--------+----------+-------------+
1 row in set, 1 warning (0.01 sec)
  ```

- index貼ってみる
  ```
  ALTER TABLE employees ADD INDEX INDEXLASTNAME(last_name);
  ```
- index貼った後の計測結果
  ```
  
  +----+-------------+-----------+------------+------+---------------+------+---------+------+--------+----------+-------------+
| id | select_type | table     | partitions | type | possible_keys | key  | key_len | ref  | rows   | filtered | Extra       |
+----+-------------+-----------+------------+------+---------------+------+---------+------+--------+----------+-------------+
|  1 | SIMPLE      | employees | NULL       | ALL  | INDEXLASTNAME | NULL | NULL    | NULL | 299113 |    20.03 | Using where |
+----+-------------+-----------+------------+------+---------------+------+---------+------+--------+----------+-------------+
1 row in set, 1 warning (0.00 sec)
  ```

- ５回くらい叩くと実行時間が短くなった
  ```
  shell
  +----+-------------+-----------+------------+------+---------------+------+---------+------+--------+----------+-------------+
| id | select_type | table     | partitions | type | possible_keys | key  | key_len | ref  | rows   | filtered | Extra       |
+----+-------------+-----------+------------+------+---------------+------+---------+------+--------+----------+-------------+
|  1 | SIMPLE      | employees | NULL       | ALL  | INDEXLASTNAME | NULL | NULL    | NULL | 299113 |    20.03 | Using where |
+----+-------------+-----------+------------+------+---------------+------+---------+------+--------+----------+-------------+
1 row in set, 1 warning (0.00 sec)
```
- 同じクエリーを叩くと実行時間が短くなるはどうして？
  - 一回目はでデータをディスクから読み込むためディスクIOが発生するが、２回目以降はディスクにアクセスせずにメモリ上にキャッシュされた結果を返却するので、２回目以降はマシンに負荷がかからず、かつ高速に応答できている。なので同じクエリーを叩くと実行時間が短くなる。
　参照　https://weblabo.oscasierra.net/mysql-query-cache/

- 10秒以上かかるクエリーを考える
  - show tables;
  - show full columns from salaries;
  - show full columns from employees;
  - select * from employees as em join salaries as sa on em.emp_no = sa.emp_no;
  - 2844047 rows in set (4.86 sec)
  - select * from employees as em join salaries as sa on em.emp_no = sa.emp_no where sa.salary > 5000 order by sa.salary DESC;
  - 2844047 rows in set (10.08 sec)
- インデックス作成
  - create index salary_index on salaries(salary);
  - select * from employees as em join salaries as sa on em.emp_no = sa.emp_no;
  - 2844047 rows in set (7.03 sec)
  - select * from employees as em join salaries as sa on em.emp_no = sa.emp_no where sa.salary > 5000 order by sa.salary DESC;
  - 2844047 rows in set (2 min 3.48 sec)
  - クエリが遅くなったのだがどうして？
  - ALTER TABLE salaries ADD INDEX SALARY(salary);
  - select * from employees as em join salaries as sa on em.emp_no = sa.emp_no where sa.salary > 5000 order by sa.salary DESC;
  - 2844047 rows in set (2 min 5.83 sec)
  - explain select * from employees as em join salaries as sa on em.emp_no = sa.emp_no where sa.salary > 5000 order by sa.salary DESC;
  - ```
  +----+-------------+-------+------------+--------+-----------------------------+--------------+---------+---------------------+------+----------+-----------------------+
| id | select_type | table | partitions | type   | possible_keys               | key          | key_len | ref                 | rows | filtered | Extra                 |
+----+-------------+-------+------------+--------+-----------------------------+--------------+---------+---------------------+------+----------+-----------------------+
|  1 | SIMPLE      | sa    | NULL       | range  | PRIMARY,salary_index,SALARY | salary_index | 4       | NULL                |    1 |   100.00 | Using index condition |
|  1 | SIMPLE      | em    | NULL       | eq_ref | PRIMARY                     | PRIMARY      | 4       | employees.sa.emp_no |    1 |   100.00 | NULL                  |
+----+-------------+-------+------------+--------+-----------------------------+--------------+---------+---------------------+------+----------+-----------------------+
```
2 rows in set, 1 warning (0.01 sec)

- 複合インデックスとは複数のカラムにインデックスをはる.
 - 例えば本があったときにタイトルだけでも検索は可能かもしれないが、タイトル＋著者名にしたほうが、効率よく検索が可能になる。
 複合インデックスイメージ
hoge A
fuga B
hoge2 C
huga2 D
hoge F

- 複合インデックスには順序があるため単独で検索条件に利用されるカラムを先頭にする必要がある。
今回の場合だとCREATE INDEX employees_name ON employees (last_name, first_name)
でインデックスを張る必要がある