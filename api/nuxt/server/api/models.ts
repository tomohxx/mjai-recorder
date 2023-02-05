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
  declare game_id: number;
  declare player_id: number;
  declare seat: number;
  declare score: number;
  declare position: number;
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
      field: "player_name",
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

Game.hasMany(GamePlayer, { foreignKey: "game_id" });
GamePlayer.belongsTo(Game, { foreignKey: "game_id" });
Player.hasMany(GamePlayer, { foreignKey: "player_id" });
GamePlayer.belongsTo(Player, { foreignKey: "player_id" });
