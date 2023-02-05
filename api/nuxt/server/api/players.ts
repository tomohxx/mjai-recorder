import { Player } from "./models";

export default defineEventHandler(async (event) => {
  const players = (
    await Player.findAll({
      attributes: ["playerName"],
    })
  ).map((player) => player.playerName);

  return players;
});
