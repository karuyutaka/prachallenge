SQLクエリで以下の式を実行した時の結果を答えてください。SELECT WHERE...の後に続くと解釈していただいて構いません
NULL = 0    NULL
NULL = NULL NULL
NULL <> NULL    NULL
NULL AND TRUE   NULL
NULL AND FALSE  FALSE
NULL OR TRUE    TRUE



task2
あまり使わない方がいいみたいだが、その辺りは臨機応変に対応するのがいいのかなという印象
ただいろんなサイトを見ると極力nullが入らないような設計にした方がいいという情報が出ていた。

task3
null || 'string'はどういう結果を返却する？