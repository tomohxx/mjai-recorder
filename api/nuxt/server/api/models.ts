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

Game.hasMany(GamePlayer, { foreignKey: "gameId" });
GamePlayer.belongsTo(Game, { foreignKey: "gameId" });

Player.hasMany(GamePlayer, { foreignKey: "playerId" });
GamePlayer.belongsTo(Player, { foreignKey: "playerId" });

Game.hasMany(Kyoku, { foreignKey: "gameId" });
Kyoku.belongsTo(Game, { foreignKey: "gameId" });

Player.belongsToMany(Game, { through: GamePlayer, foreignKey: "playerId" });
Game.belongsToMany(Player, { through: GamePlayer, foreignKey: "gameId" });
