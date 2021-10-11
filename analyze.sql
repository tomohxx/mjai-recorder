\echo *************************************************************
\echo * Mjai Recoder Report (`date`)
\echo * :NAME
\echo *************************************************************

\pset footer
\echo

SELECT
COUNT(*) AS 試合数,
ROUND(AVG(player.position), 3) AS 平均順位,
ROUND(AVG(player.score), 0) AS 平均最終持ち点,
ROUND(COUNT(CASE WHEN player.position = 1 THEN 1 ELSE NULL END)::NUMERIC / NULLIF(COUNT(*), 0), 3) AS 一位率,
ROUND(COUNT(CASE WHEN player.position = 2 THEN 1 ELSE NULL END)::NUMERIC / NULLIF(COUNT(*), 0), 3) AS 二位率,
ROUND(COUNT(CASE WHEN player.position = 3 THEN 1 ELSE NULL END)::NUMERIC / NULLIF(COUNT(*), 0), 3) AS 三位率,
ROUND(COUNT(CASE WHEN player.position = 4 THEN 1 ELSE NULL END)::NUMERIC / NULLIF(COUNT(*), 0), 3) AS 四位率,
ROUND(COUNT(CASE WHEN player.seat = 0 THEN 1 ELSE NULL END)::NUMERIC / NULLIF(COUNT(*), 0), 3) AS 東家率,
ROUND(COUNT(CASE WHEN player.seat = 1 THEN 1 ELSE NULL END)::NUMERIC / NULLIF(COUNT(*), 0), 3) AS 南家率,
ROUND(COUNT(CASE WHEN player.seat = 2 THEN 1 ELSE NULL END)::NUMERIC / NULLIF(COUNT(*), 0), 3) AS 西家率,
ROUND(COUNT(CASE WHEN player.seat = 3 THEN 1 ELSE NULL END)::NUMERIC / NULLIF(COUNT(*), 0), 3) AS 北家率
FROM player
INNER JOIN game
ON player.game_id = game.id
  AND NOT game.error_flag
WHERE player.player_name = :'NAME';

SELECT
COUNT(*) AS 局数,
ROUND(COUNT(hora_actor.id)::NUMERIC / NULLIF(COUNT(*), 0), 3) AS 和了率,
ROUND(COUNT(CASE WHEN hora_actor.actor_id = hora_actor.target_id THEN 1 ELSE NULL END)::NUMERIC / NULLIF(COUNT(hora_actor.id), 0), 3) AS 自摸率,
ROUND(COUNT(CASE WHEN hora_target.actor_id <> hora_target.target_id THEN 1 ELSE NULL END)::NUMERIC / NULLIF(COUNT(*), 0), 3) AS 放銃率,
ROUND(AVG(hora_actor.delta), 0) AS 平均得点,
ROUND(AVG(CASE WHEN hora_target.actor_id <> hora_target.target_id THEN hora_target.delta ELSE NULL END), 0) AS 平均失点,
ROUND(COUNT(riichi.id)::NUMERIC / NULLIF(COUNT(*), 0), 3) AS 立直率,
ROUND(COUNT(naki_.actor_id)::NUMERIC / NULLIF(COUNT(*), 0), 3) AS 副露率,
ROUND(COUNT(ryukyoku.id)::NUMERIC / NULLIF(COUNT(*), 0), 3) AS 流局率,
ROUND(COUNT(CASE WHEN ryukyoku.tenpai THEN 1 ELSE NULL END)::NUMERIC / NULLIF(COUNT(ryukyoku.id), 0), 3) AS 流局時聴牌率
FROM kyoku
INNER JOIN player
ON kyoku.game_id = player.game_id
  AND player.player_name = :'NAME'
INNER JOIN game
ON kyoku.game_id = game.id
  AND NOT game.error_flag
LEFT OUTER JOIN hora AS hora_actor
ON kyoku.id = hora_actor.kyoku_id
  AND player.id = hora_actor.actor_id
LEFT OUTER JOIN hora AS hora_target
ON kyoku.id = hora_target.kyoku_id
  AND player.id = hora_target.target_id
LEFT OUTER JOIN riichi
ON kyoku.id = riichi.kyoku_id
  AND player.id = riichi.player_id
LEFT OUTER JOIN (
  SELECT DISTINCT
  actor_id, kyoku_id
  FROM naki
) AS naki_
ON kyoku.id = naki_.kyoku_id
  AND player.id = naki_.actor_id
LEFT OUTER JOIN ryukyoku
ON kyoku.id = ryukyoku.kyoku_id
  AND player.id = ryukyoku.player_id;
