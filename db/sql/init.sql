CREATE TABLE games (
  id SERIAL NOT NULL PRIMARY KEY,
  file_name VARCHAR(255) UNIQUE NOT NULL,
  error_flag BOOLEAN DEFAULT FALSE
);

CREATE TABLE players (
  id SERIAL NOT NULL PRIMARY KEY,
  seat INTEGER NOT NULL,
  game_id INTEGER NOT NULL,
  player_name VARCHAR(255) NOT NULL,
  score INTEGER,
  position INTEGER,
  FOREIGN KEY(game_id) REFERENCES games(id) ON DELETE CASCADE
);

CREATE TABLE rounds(
  id SERIAL NOT NULL PRIMARY KEY,
  game_id INTEGER NOT NULL,
  bakaze CHAR(1) NOT NULL CHECK(bakaze IN ('E', 'S', 'W')),
  kyoku INTEGER NOT NULL,
  honba INTEGER NOT NULL,
  FOREIGN KEY(game_id) REFERENCES games(id) ON DELETE CASCADE
);

CREATE TABLE winnings(
  id SERIAL NOT NULL PRIMARY KEY,
  actor_id INTEGER NOT NULL,
  target_id INTEGER NOT NULL,
  delta INTEGER NOT NULL,
  round_id INTEGER NOT NULL,
  FOREIGN KEY(actor_id) REFERENCES players(id) ON DELETE CASCADE,
  FOREIGN KEY(target_id) REFERENCES players(id) ON DELETE CASCADE,
  FOREIGN KEY(round_id) REFERENCES rounds(id) ON DELETE CASCADE
);

CREATE TABLE ryukyokus(
  id SERIAL NOT NULL PRIMARY KEY,
  player_id INTEGER NOT NULL,
  tenpai BOOLEAN NOT NULL,
  round_id INTEGER NOT NULL,
  FOREIGN KEY(player_id) REFERENCES players(id) ON DELETE CASCADE,
  FOREIGN KEY(round_id) REFERENCES rounds(id) ON DELETE CASCADE
);

CREATE TABLE riichis(
  id SERIAL NOT NULL PRIMARY KEY,
  player_id INTEGER NOT NULL,
  round_id INTEGER NOT NULL,
  FOREIGN KEY(player_id) REFERENCES players(id) ON DELETE CASCADE,
  FOREIGN KEY(round_id) REFERENCES rounds(id) ON DELETE CASCADE
);

CREATE TABLE nakis(
  id SERIAL NOT NULL PRIMARY KEY,
  actor_id INTEGER NOT NULL,
  target_id INTEGER,
  round_id INTEGER NOT NULL,
  FOREIGN KEY(actor_id) REFERENCES players(id) ON DELETE CASCADE,
  FOREIGN KEY(target_id) REFERENCES players(id) ON DELETE CASCADE,
  FOREIGN KEY(round_id) REFERENCES rounds(id) ON DELETE CASCADE
);
