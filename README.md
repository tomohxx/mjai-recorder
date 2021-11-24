# Mjai Recoder
Mjaiイベントログ管理ツール

## 機能
- Mjaiサーバー(ポート番号: 11600)
- DBサーバー(ポート番号: 5432)
- ログ閲覧(ポート番号: 8000)

## ER図
![ER図](relationships.real.large.png)

### 出力コマンド
```shell
$ docker run -v "$PWD/output:/output" -v "$PWD/schemaspy.properties:/schemaspy.properties" --net=host --rm schemaspy/schemaspy
```
