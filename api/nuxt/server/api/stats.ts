import { Op } from "sequelize";
import { Player, GamePlayer } from "./models";

async function getNumGame(playerName: string) {
  return await GamePlayer.count({
    where: {
      score: { [Op.not]: null },
    },
    include: {
      model: Player,
      required: true,
      where: {
        playerName,
      },
    },
  });
}

export default defineEventHandler(async (event) => {
  const query = getQuery(event);
  const playerName = query.playerName?.toString() || "";
  const numGame = await getNumGame(playerName);

  return { numGame };
});
