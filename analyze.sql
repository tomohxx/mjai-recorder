\echo *************************************************************
\echo * Mjai Recoder Report (`date`)
\echo * :NAME
\echo *************************************************************

\pset footer
\echo

SELECT
COUNT(*) AS 試合数,
ROUND(AVG(players.position), 3) AS 平均順位,
ROUND(AVG(players.score), 0) AS 平均最終持ち点,
ROUND(COUNT(CASE WHEN players.position = 1 THEN 1 ELSE NULL END)::NUMERIC / NULLIF(COUNT(*), 0), 3) AS 一位率,
ROUND(COUNT(CASE WHEN players.position = 2 THEN 1 ELSE NULL END)::NUMERIC / NULLIF(COUNT(*), 0), 3) AS 二位率,
ROUND(COUNT(CASE WHEN players.position = 3 THEN 1 ELSE NULL END)::NUMERIC / NULLIF(COUNT(*), 0), 3) AS 三位率,
ROUND(COUNT(CASE WHEN players.position = 4 THEN 1 ELSE NULL END)::NUMERIC / NULLIF(COUNT(*), 0), 3) AS 四位率,
ROUND(COUNT(CASE WHEN players.seat = 0 THEN 1 ELSE NULL END)::NUMERIC / NULLIF(COUNT(*), 0), 3) AS 東家率,
ROUND(COUNT(CASE WHEN players.seat = 1 THEN 1 ELSE NULL END)::NUMERIC / NULLIF(COUNT(*), 0), 3) AS 南家率,
ROUND(COUNT(CASE WHEN players.seat = 2 THEN 1 ELSE NULL END)::NUMERIC / NULLIF(COUNT(*), 0), 3) AS 西家率,
ROUND(COUNT(CASE WHEN players.seat = 3 THEN 1 ELSE NULL END)::NUMERIC / NULLIF(COUNT(*), 0), 3) AS 北家率
FROM players
INNER JOIN games
ON players.game_id = games.id
  AND NOT games.error_flag
WHERE players.player_name = :'NAME';

SELECT
COUNT(*) AS 局数,
ROUND(COUNT(actors.id)::NUMERIC / NULLIF(COUNT(*), 0), 3) AS 和了率,
ROUND(COUNT(CASE WHEN actors.actor_id = actors.target_id THEN 1 ELSE NULL END)::NUMERIC / NULLIF(COUNT(actors.id), 0), 3) AS 自摸率,
ROUND(COUNT(CASE WHEN targets.actor_id <> targets.target_id THEN 1 ELSE NULL END)::NUMERIC / NULLIF(COUNT(*), 0), 3) AS 放銃率,
ROUND(AVG(actors.delta), 0) AS 平均得点,
ROUND(AVG(CASE WHEN targets.actor_id <> targets.target_id THEN targets.delta ELSE NULL END), 0) AS 平均失点,
ROUND(COUNT(riichis.id)::NUMERIC / NULLIF(COUNT(*), 0), 3) AS 立直率,
ROUND(COUNT(nakis_.actor_id)::NUMERIC / NULLIF(COUNT(*), 0), 3) AS 副露率,
ROUND(COUNT(ryukyokus.id)::NUMERIC / NULLIF(COUNT(*), 0), 3) AS 流局率,
ROUND(COUNT(CASE WHEN ryukyokus.tenpai THEN 1 ELSE NULL END)::NUMERIC / NULLIF(COUNT(ryukyokus.id), 0), 3) AS 流局時聴牌率
FROM rounds
INNER JOIN players
ON rounds.game_id = players.game_id
  AND players.player_name = :'NAME'
INNER JOIN games
ON rounds.game_id = games.id
  AND NOT games.error_flag
LEFT OUTER JOIN winnings AS actors
ON rounds.id = actors.round_id
  AND players.id = actors.actor_id
LEFT OUTER JOIN winnings AS targets
ON rounds.id = targets.round_id
  AND players.id = targets.target_id
LEFT OUTER JOIN riichis
ON rounds.id = riichis.round_id
  AND players.id = riichis.player_id
LEFT OUTER JOIN (
  SELECT DISTINCT
  actor_id, round_id
  FROM nakis
) AS nakis_
ON rounds.id = nakis_.round_id
  AND players.id = nakis_.actor_id
LEFT OUTER JOIN ryukyokus
ON rounds.id = ryukyokus.round_id
  AND players.id = ryukyokus.player_id;
