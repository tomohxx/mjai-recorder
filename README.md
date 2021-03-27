# Mjai Recoder
Mjaiイベントログ管理ツール

## 機能
- ポート番号11600でMjaiサーバー機能を提供する.
- ポート番号5432でDBサーバー機能を提供する.
- ポート番号8080でログ閲覧機能を提供する.

## ER図
![ER図](relationships.real.large.png)

## SQLコマンド例

- *Player*の試合数
```sql
select count(*) from games inner join players on games.id = players.game_id where players.name = 'Player';
```

- *Player*の局数
```sql
select count(*) from rounds inner join players on rounds.game_id = players.game_id where players.name = 'Player';
```

- *Player*の和了回数
```sql
select count(*) from winnings inner join players on winnings.actor = players.id where players.name = 'Player';
```

- *Player*の放銃回数
```sql
select count(*) from winnings inner join players on winnings.target = players.id where winnings.actor != players.id and players.name = 'Player';
```

- *Player*の直近10試合の順位
```sql
select results.position from results inner join players on results.player_id = players.id where players.name = 'Player' limit 10;
```

- *Player*の順位ごとの記録回数
```sql
select ranking.position, count(ranking.position) from (select results.position from results inner join players on results.player_id = players.id where players.name = 'Player') as ranking group by ranking.position order by ranking.position;
```
