import { Player } from "./models";

export default defineEventHandler(async (event) => {
  const players = await Player.findAll({
    attributes: ["id", "playerName"],
  });

  return players;
});
