CREATE TABLE games (
  id SERIAL NOT NULL PRIMARY KEY,
  file_name VARCHAR(255) UNIQUE NOT NULL
);

CREATE TABLE player_names (
  id SERIAL NOT NULL PRIMARY KEY,
  player_name VARCHAR(255) UNIQUE NOT NULL
);

CREATE TABLE players (
  id SERIAL NOT NULL PRIMARY KEY,
  seat INTEGER NOT NULL,
  game_id INTEGER NOT NULL,
  player_name_id INTEGER NOT NULL,
  FOREIGN KEY (game_id) REFERENCES games (id),
  FOREIGN KEY (player_name_id) REFERENCES player_names (id)
);

CREATE TABLE rounds (
  id SERIAL NOT NULL PRIMARY KEY,
  game_id INTEGER NOT NULL,
  FOREIGN KEY (game_id) REFERENCES games (id)
);

CREATE TABLE winnings (
  id SERIAL NOT NULL PRIMARY KEY,
  actor_id INTEGER NOT NULL,
  target_id INTEGER NOT NULL,
  delta INTEGER NOT NULL,
  round_id INTEGER NOT NULL,
  FOREIGN KEY (actor_id) REFERENCES players (id),
  FOREIGN KEY (target_id) REFERENCES players (id),
  FOREIGN KEY (round_id) REFERENCES rounds (id)
);

CREATE TABLE ryukyokus (
  id SERIAL NOT NULL PRIMARY KEY,
  player_id INTEGER NOT NULL,
  tenpai BOOLEAN NOT NULL,
  round_id INTEGER NOT NULL,
  FOREIGN KEY (player_id) REFERENCES players (id),
  FOREIGN KEY (round_id) REFERENCES rounds (id)
);

CREATE TABLE results (
  id SERIAL NOT NULL PRIMARY KEY,
  player_id INTEGER UNIQUE NOT NULL,
  score INTEGER NOT NULL,
  position INTEGER NOT NULL,
  FOREIGN KEY (player_id) REFERENCES players (id)
);

CREATE TABLE riichis (
  id SERIAL NOT NULL PRIMARY KEY,
  player_id INTEGER NOT NULL,
  round_id INTEGER NOT NULL,
  FOREIGN KEY (player_id) REFERENCES players (id),
  FOREIGN KEY (round_id) REFERENCES rounds (id)
);

CREATE TABLE nakis (
  id SERIAL NOT NULL PRIMARY KEY,
  actor_id INTEGER NOT NULL,
  target_id INTEGER NOT NULL,
  round_id INTEGER NOT NULL,
  FOREIGN KEY (actor_id) REFERENCES players (id),
  FOREIGN KEY (target_id) REFERENCES players (id),
  FOREIGN KEY (round_id) REFERENCES rounds (id)
);
