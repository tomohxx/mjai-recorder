import { Sequelize, Model, DataTypes } from "sequelize";

const config = useRuntimeConfig();

const sequelize = new Sequelize(config.db_uri);

export class Game extends Model {
  declare id: number;
  declare fileName: string;
  declare errorFlag: boolean;
}

export class Player extends Model {
  declare id: number;
  declare playerName: string;
}

export class GamePlayer extends Model {
  declare id: number;
  declare gameId: number;
  declare playerId: number;
  declare seat: number;
  declare score: number;
  declare position: number;
}

export class Kyoku extends Model {
  declare id: number;
  declare gameId: number;
  declare bakaze: string;
  declare kyoku: number;
  declare honba: string;
}

export class Hora extends Model {
  declare id: number;
  declare actorId: number;
  declare targetId: number;
  declare delta: number;
  declare kyokuId: number;
}

export class Ryukyoku extends Model {
  declare id: number;
  declare playerId: number;
  declare tenpai: boolean;
  declare kyokuId: number;
}

export class Riichi extends Model {
  declare id: number;
  declare playerId: number;
  declare kyokuId: number;
}

export class Naki extends Model {
  declare id: number;
  declare actorId: number;
  declare targetId: number;
  declare kyokuId: number;
  declare nakiType: string;
}

Game.init(
  {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
    },
    fileName: {
      type: DataTypes.STRING,
      allowNull: false,
      unique: true,
      field: "file_name",
    },
    errorFlag: {
      type: DataTypes.BOOLEAN,
      defaultValue: false,
      field: "error_flag",
    },
  },
  {
    sequelize,
    tableName: "game",
    timestamps: false,
  }
);

Player.init(
  {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
    },
    playerName: {
      type: DataTypes.STRING,
      allowNull: false,
      unique: true,
      field: "player_name",
    },
  },
  {
    sequelize,
    tableName: "player",
    timestamps: false,
  }
);

GamePlayer.init(
  {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
    },
    gameId: {
      type: DataTypes.INTEGER,
      references: {
        model: Game,
        key: "id",
      },
      allowNull: false,
      field: "game_id",
    },
    playerId: {
      type: DataTypes.INTEGER,
      references: {
        model: Player,
        key: "id",
      },
      allowNull: false,
      field: "player_id",
    },
    seat: {
      type: DataTypes.INTEGER,
      allowNull: false,
    },
    score: {
      type: DataTypes.INTEGER,
    },
    position: {
      type: DataTypes.INTEGER,
    },
  },
  {
    sequelize,
    tableName: "game_player",
    timestamps: false,
  }
);

Kyoku.init(
  {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
    },
    gameId: {
      type: DataTypes.INTEGER,
      references: {
        model: Game,
        key: "id",
      },
      allowNull: false,
      field: "game_id",
    },
    bakaze: {
      type: DataTypes.CHAR(1),
      allowNull: false,
    },
    kyoku: {
      type: DataTypes.INTEGER,
      allowNull: false,
    },
    honba: {
      type: DataTypes.INTEGER,
      allowNull: false,
    },
  },
  {
    sequelize,
    tableName: "kyoku",
    timestamps: false,
  }
);

Hora.init(
  {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
    },
    actorId: {
      type: DataTypes.INTEGER,
      references: {
        model: Player,
        key: "id",
      },
      allowNull: false,
      field: "actor_id",
    },
    targetId: {
      type: DataTypes.INTEGER,
      references: {
        model: Player,
        key: "id",
      },
      allowNull: false,
      field: "target_id",
    },
    delta: {
      type: DataTypes.INTEGER,
      allowNull: false,
    },
    kyokuId: {
      type: DataTypes.INTEGER,
      references: {
        model: Kyoku,
        key: "id",
      },
      allowNull: false,
      field: "kyoku_id",
    },
    honba: {
      type: DataTypes.INTEGER,
      allowNull: false,
    },
  },
  {
    sequelize,
    tableName: "hora",
    timestamps: false,
  }
);

Ryukyoku.init(
  {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
    },
    playerId: {
      type: DataTypes.INTEGER,
      references: {
        model: Player,
        key: "id",
      },
      allowNull: false,
      field: "player_id",
    },
    tenpai: {
      type: DataTypes.BOOLEAN,
      allowNull: false,
    },
    kyokuId: {
      type: DataTypes.INTEGER,
      references: {
        model: Kyoku,
        key: "id",
      },
      allowNull: false,
      field: "kyoku_id",
    },
  },
  {
    sequelize,
    tableName: "ryukyoku",
    timestamps: false,
  }
);

Riichi.init(
  {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
    },
    playerId: {
      type: DataTypes.INTEGER,
      references: {
        model: Player,
        key: "id",
      },
      allowNull: false,
      field: "player_id",
    },
    kyokuId: {
      type: DataTypes.INTEGER,
      references: {
        model: Kyoku,
        key: "id",
      },
      allowNull: false,
      field: "kyoku_id",
    },
  },
  {
    sequelize,
    tableName: "riichi",
    timestamps: false,
  }
);

Naki.init(
  {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
    },
    actorId: {
      type: DataTypes.INTEGER,
      references: {
        model: Player,
        key: "id",
      },
      allowNull: false,
      field: "actor_id",
    },
    targetId: {
      type: DataTypes.INTEGER,
      references: {
        model: Player,
        key: "id",
      },
      allowNull: false,
      field: "target_id",
    },
    kyokuId: {
      type: DataTypes.INTEGER,
      references: {
        model: Kyoku,
        key: "id",
      },
      allowNull: false,
      field: "kyoku_id",
    },
    nakiType: {
      type: DataTypes.STRING,
      allowNull: false,
      field: "naki_type",
    },
  },
  {
    sequelize,
    tableName: "naki",
    timestamps: false,
  }
);

Game.hasMany(GamePlayer, { foreignKey: "gameId" });
GamePlayer.belongsTo(Game, { foreignKey: "gameId" });

Player.hasMany(GamePlayer, { foreignKey: "playerId" });
GamePlayer.belongsTo(Player, { foreignKey: "playerId" });

Game.hasMany(Kyoku, { foreignKey: "gameId" });
Kyoku.belongsTo(Game, { foreignKey: "gameId" });

Player.belongsToMany(Game, { through: GamePlayer, foreignKey: "playerId" });
Game.belongsToMany(Player, { through: GamePlayer, foreignKey: "gameId" });

Kyoku.hasMany(Hora, { foreignKey: "kyokuId" });
Hora.belongsTo(Kyoku, { foreignKey: "kyokuId" });

Player.hasMany(Hora, { as: "HoraActor", foreignKey: "actorId" });
Player.hasMany(Hora, { as: "HoraTaregt", foreignKey: "targetId" });
Hora.belongsTo(Player, { as: "HoraActor", foreignKey: "actorId" });
Hora.belongsTo(Player, { as: "HoraTarget", foreignKey: "targetId" });

Player.hasMany(Ryukyoku, { foreignKey: "playerId" });
Ryukyoku.belongsTo(Player, { foreignKey: "playerId" });

Kyoku.hasMany(Ryukyoku, { foreignKey: "kyoku_id" });
Ryukyoku.belongsTo(Kyoku, { foreignKey: "kyoku_id" });

Player.hasMany(Riichi, { foreignKey: "playerId" });
Riichi.belongsTo(Player, { foreignKey: "playerId" });

Kyoku.hasMany(Riichi, { foreignKey: "kyokuId" });
Riichi.belongsTo(Kyoku, { foreignKey: "kyokuId" });

Kyoku.hasMany(Naki, { foreignKey: "kyokuId" });
Naki.belongsTo(Kyoku, { foreignKey: "kyokuId" });

Player.hasMany(Naki, { as: "NakiActor", foreignKey: "actorId" });
Player.hasMany(Naki, { as: "NakiTaregt", foreignKey: "targetId" });
Naki.belongsTo(Player, { as: "NakiActor", foreignKey: "actorId" });
Naki.belongsTo(Player, { as: "NakiTarget", foreignKey: "targetId" });
