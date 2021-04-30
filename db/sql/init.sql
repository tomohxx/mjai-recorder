CREATE TABLE games (
  id SERIAL NOT NULL PRIMARY KEY,
  file_name VARCHAR(255) NOT NULL
);

CREATE TABLE players (
  id SERIAL NOT NULL PRIMARY KEY,
  seat INTEGER NOT NULL,
  game_id INTEGER NOT NULL,
  name VARCHAR(255) NOT NULL,
  FOREIGN KEY (game_id) REFERENCES games (id)
);

CREATE TABLE rounds (
  id SERIAL NOT NULL PRIMARY KEY,
  game_id INTEGER NOT NULL,
  FOREIGN KEY (game_id) REFERENCES games (id)
);

CREATE TABLE winnings (
  id SERIAL NOT NULL PRIMARY KEY,
  actor INTEGER NOT NULL,
  target INTEGER NOT NULL,
  delta INTEGER NOT NULL,
  round_id INTEGER NOT NULL,
  FOREIGN KEY (actor) REFERENCES players (id),
  FOREIGN KEY (target) REFERENCES players (id),
  FOREIGN KEY (round_id) REFERENCES rounds (id)
);

CREATE TABLE results (
  player_id INTEGER NOT NULL PRIMARY KEY,
  game_id INTEGER NOT NULL,
  score INTEGER NOT NULL,
  position INTEGER NOT NULL,
  FOREIGN KEY (player_id) REFERENCES players (id),
  FOREIGN KEY (game_id) REFERENCES games (id)
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
  actor INTEGER NOT NULL,
  target INTEGER NOT NULL,
  round_id INTEGER NOT NULL,
  FOREIGN KEY (actor) REFERENCES players (id),
  FOREIGN KEY (target) REFERENCES players (id),
  FOREIGN KEY (round_id) REFERENCES rounds (id)
);
