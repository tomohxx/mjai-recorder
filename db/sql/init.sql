CREATE TABLE game(
  id SERIAL NOT NULL PRIMARY KEY,
  file_name VARCHAR(255) UNIQUE NOT NULL,
  error_flag BOOLEAN DEFAULT FALSE
);

CREATE TABLE player(
  id SERIAL NOT NULL PRIMARY KEY,
  seat INTEGER NOT NULL,
  game_id INTEGER NOT NULL,
  player_name VARCHAR(255) NOT NULL,
  score INTEGER,
  position INTEGER,
  FOREIGN KEY(game_id) REFERENCES game(id) ON DELETE CASCADE
);

CREATE TABLE kyoku(
  id SERIAL NOT NULL PRIMARY KEY,
  game_id INTEGER NOT NULL,
  bakaze CHAR(1) NOT NULL CHECK(bakaze IN ('E', 'S', 'W')),
  kyoku INTEGER NOT NULL,
  honba INTEGER NOT NULL,
  FOREIGN KEY(game_id) REFERENCES game(id) ON DELETE CASCADE
);

CREATE TABLE hora(
  id SERIAL NOT NULL PRIMARY KEY,
  actor_id INTEGER NOT NULL,
  target_id INTEGER NOT NULL,
  delta INTEGER NOT NULL,
  kyoku_id INTEGER NOT NULL,
  FOREIGN KEY(actor_id) REFERENCES player(id) ON DELETE CASCADE,
  FOREIGN KEY(target_id) REFERENCES player(id) ON DELETE CASCADE,
  FOREIGN KEY(kyoku_id) REFERENCES kyoku(id) ON DELETE CASCADE
);

CREATE TABLE ryukyoku(
  id SERIAL NOT NULL PRIMARY KEY,
  player_id INTEGER NOT NULL,
  tenpai BOOLEAN NOT NULL,
  kyoku_id INTEGER NOT NULL,
  FOREIGN KEY(player_id) REFERENCES player(id) ON DELETE CASCADE,
  FOREIGN KEY(kyoku_id) REFERENCES kyoku(id) ON DELETE CASCADE
);

CREATE TABLE riichi(
  id SERIAL NOT NULL PRIMARY KEY,
  player_id INTEGER NOT NULL,
  kyoku_id INTEGER NOT NULL,
  FOREIGN KEY(player_id) REFERENCES player(id) ON DELETE CASCADE,
  FOREIGN KEY(kyoku_id) REFERENCES kyoku(id) ON DELETE CASCADE
);

CREATE TABLE naki(
  id SERIAL NOT NULL PRIMARY KEY,
  actor_id INTEGER NOT NULL,
  target_id INTEGER NOT NULL,
  kyoku_id INTEGER NOT NULL,
  naki_type CHAR(10) NOT NULL CHECK(naki_type IN ('pon', 'chi', 'daiminkan')),
  FOREIGN KEY(actor_id) REFERENCES player(id) ON DELETE CASCADE,
  FOREIGN KEY(target_id) REFERENCES player(id) ON DELETE CASCADE,
  FOREIGN KEY(kyoku_id) REFERENCES kyoku(id) ON DELETE CASCADE
);

CREATE VIEW player_list AS
SELECT
DISTINCT player_name
FROM player
ORDER BY player_name;

CREATE OR REPLACE FUNCTION stat_game(arg VARCHAR)
RETURNS TABLE(
  num_games BIGINT,
  avg_ranking NUMERIC,
  avg_final_score NUMERIC,
  rate_first NUMERIC,
  rate_second NUMERIC,
  rate_third NUMERIC,
  rate_fourth NUMERIC,
  rate_east NUMERIC,
  rate_south NUMERIC,
  rate_west NUMERIC,
  rate_north NUMERIC) AS $$
BEGIN
  RETURN QUERY SELECT
  COUNT(*),
  ROUND(AVG(player.position), 3),
  ROUND(AVG(player.score), 0),
  ROUND(
    COUNT(
      CASE
        WHEN player.position = 1 THEN 1
        ELSE NULL
      END)::NUMERIC / NULLIF(COUNT(*), 0), 3),
  ROUND(
    COUNT(
      CASE
        WHEN player.position = 2 THEN 1
        ELSE NULL
      END)::NUMERIC / NULLIF(COUNT(*), 0), 3),
  ROUND(
    COUNT(
      CASE
        WHEN player.position = 3 THEN 1
        ELSE NULL
      END)::NUMERIC / NULLIF(COUNT(*), 0), 3),
  ROUND(
    COUNT(
      CASE
        WHEN player.position = 4 THEN 1
        ELSE NULL
      END)::NUMERIC / NULLIF(COUNT(*), 0), 3),
  ROUND(
    COUNT(
      CASE
        WHEN player.seat = 0 THEN 1
        ELSE NULL
      END)::NUMERIC / NULLIF(COUNT(*), 0), 3),
  ROUND(
    COUNT(
      CASE
        WHEN player.seat = 1 THEN 1
        ELSE NULL
      END)::NUMERIC / NULLIF(COUNT(*), 0), 3),
  ROUND(
    COUNT(
      CASE
        WHEN player.seat = 2 THEN 1
        ELSE NULL
      END)::NUMERIC / NULLIF(COUNT(*), 0), 3),
  ROUND(
    COUNT(
      CASE
        WHEN player.seat = 3 THEN 1
        ELSE NULL
      END)::NUMERIC / NULLIF(COUNT(*), 0), 3)
  FROM player
  INNER JOIN game
  ON player.game_id = game.id
    AND NOT game.error_flag
  WHERE player.player_name = arg;
END;
$$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION stat_kyoku(arg VARCHAR)
RETURNS TABLE(
  num_kyoku BIGINT,
  rate_hora NUMERIC,
  rate_tsumo NUMERIC,
  rate_houju NUMERIC,
  avg_score NUMERIC,
  avg_loss NUMERIC,
  rate_riichi NUMERIC,
  rate_naki NUMERIC,
  rate_ryukyoku NUMERIC,
  rate_tenpai NUMERIC) AS $$
BEGIN
  RETURN QUERY SELECT
  COUNT(*),
  ROUND(COUNT(hora_actor.id)::NUMERIC / NULLIF(COUNT(*), 0), 3),
  ROUND(
    COUNT(
      CASE
        WHEN hora_actor.actor_id = hora_actor.target_id THEN 1
        ELSE NULL
      END)::NUMERIC / NULLIF(COUNT(hora_actor.id), 0), 3),
  ROUND(
    COUNT(
      CASE WHEN hora_target.actor_id <> hora_target.target_id THEN 1
      ELSE NULL
    END)::NUMERIC / NULLIF(COUNT(*), 0), 3),
  ROUND(AVG(hora_actor.delta), 0),
  ROUND(
    AVG(
      CASE
        WHEN hora_target.actor_id <> hora_target.target_id THEN hora_target.delta
        ELSE NULL
      END), 0),
  ROUND(COUNT(riichi.id)::NUMERIC / NULLIF(COUNT(*), 0), 3),
  ROUND(COUNT(naki_.actor_id)::NUMERIC / NULLIF(COUNT(*), 0), 3),
  ROUND(COUNT(ryukyoku.id)::NUMERIC / NULLIF(COUNT(*), 0), 3),
  ROUND(
    COUNT(
      CASE WHEN ryukyoku.tenpai THEN 1
      ELSE NULL
    END)::NUMERIC / NULLIF(COUNT(ryukyoku.id), 0), 3)
  FROM kyoku
  INNER JOIN player
  ON kyoku.game_id = player.game_id
    AND player.player_name = arg
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
END;
$$ LANGUAGE plpgsql IMMUTABLE;
