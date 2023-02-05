import { Op } from "sequelize";
import { Player, GamePlayer } from "./models";

async function getNumGame(playerId: number) {
  return await GamePlayer.count({
    where: {
      playerId,
      score: { [Op.not]: null },
    },
  });
}

export default defineEventHandler(async (event) => {
  const query = getQuery(event);
  const playerId = Number(query.playerId);
  const numGame = await getNumGame(playerId);

  return { numGame };
});
