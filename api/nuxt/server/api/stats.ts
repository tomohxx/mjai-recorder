import { Op } from "sequelize";
import { Game, Player, GamePlayer, Kyoku } from "./models";

async function getNumGame(playerId: number) {
  return await GamePlayer.count({
    where: {
      playerId,
      score: { [Op.not]: null },
    },
  });
}

async function getNumKyoku(playerId: number) {
  return await Kyoku.count({
    include: [
      {
        model: Game,
        required: true,
        where: { errorFlag: false },
        include: [
          {
            model: GamePlayer,
            required: true,
            where: {
              playerId,
            },
          },
        ],
      },
    ],
  });
}

export default defineEventHandler(async (event) => {
  const query = getQuery(event);
  const playerId = Number(query.playerId);
  const numGame = await getNumGame(playerId);
  const numKyoku = await getNumKyoku(playerId);

  return {
    numGame,
    numKyoku,
  };
});
