import { Op } from "sequelize";
import {
  Game,
  GamePlayer,
  Kyoku,
  Hora,
  Ryukyoku,
  Riichi,
  Naki,
} from "./models";

async function getNumGame(playerId: number): Promise<number> {
  return GamePlayer.count({
    where: {
      playerId,
      score: { [Op.not]: null },
    },
  });
}

async function getSumRank(playerId: number): Promise<number> {
  return GamePlayer.sum("position", {
    where: { playerId },
  });
}

async function getSumScore(playerId: number): Promise<number> {
  return GamePlayer.sum("score", {
    where: { playerId },
  });
}

async function getNumRank(playerId: number, position: number): Promise<number> {
  return GamePlayer.count({
    where: {
      playerId,
      position,
    },
  });
}

async function getNumSeat(playerId: number, seat: number): Promise<number> {
  return GamePlayer.count({
    where: {
      playerId,
      seat,
      score: { [Op.not]: null },
    },
  });
}

async function getNumKyoku(playerId: number): Promise<number> {
  return Kyoku.count({
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

async function getNumHora(playerId: number): Promise<[number, number]> {
  const { count, rows } = await Hora.findAndCountAll({
    attributes: ["delta"],
    where: { actorId: playerId },
    include: [
      {
        model: Kyoku,
        required: true,
        include: [
          {
            model: Game,
            required: true,
            where: { errorFlag: false },
          },
        ],
      },
    ],
  });

  const sum = rows.reduce((prev, { delta }) => {
    return prev + delta;
  }, 0);

  return [count, sum];
}

async function getNumTsumo(playerId: number): Promise<number> {
  return Hora.count({
    where: {
      actorId: playerId,
      targetId: playerId,
    },
    include: [
      {
        model: Kyoku,
        required: true,
        include: [
          {
            model: Game,
            required: true,
            where: { errorFlag: false },
          },
        ],
      },
    ],
  });
}

async function getNumHouju(playerId: number): Promise<[number, number]> {
  const { count, rows } = await Hora.findAndCountAll({
    attributes: ["delta"],
    where: {
      actorId: { [Op.ne]: playerId },
      targetId: playerId,
    },
    include: [
      {
        model: Kyoku,
        required: true,
        include: [
          {
            model: Game,
            required: true,
            where: { errorFlag: false },
          },
        ],
      },
    ],
  });

  const sum = rows.reduce((prev, { delta }) => {
    return prev + delta;
  }, 0);

  return [count, sum];
}

async function getNumRyukyoku(playerId: number): Promise<number> {
  return Ryukyoku.count({
    where: { playerId },
    include: [
      {
        model: Kyoku,
        required: true,
        include: [
          {
            model: Game,
            required: true,
            where: { errorFlag: false },
          },
        ],
      },
    ],
  });
}

async function getNumTenpai(playerId: number): Promise<number> {
  return Ryukyoku.count({
    where: {
      playerId,
      tenpai: true,
    },
    include: [
      {
        model: Kyoku,
        required: true,
        include: [
          {
            model: Game,
            required: true,
            where: { errorFlag: false },
          },
        ],
      },
    ],
  });
}

async function getNumRiichi(playerId: number): Promise<number> {
  return Riichi.count({
    where: { playerId },
    include: [
      {
        model: Kyoku,
        required: true,
        include: [
          {
            model: Game,
            required: true,
            where: { errorFlag: false },
          },
        ],
      },
    ],
  });
}

async function getNumNaki(playerId: number): Promise<number> {
  return Naki.count({
    where: { actorId: playerId },
    include: [
      {
        model: Kyoku,
        required: true,
        include: [
          {
            model: Game,
            required: true,
            where: { errorFlag: false },
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
  const sumRank = await getSumRank(playerId);
  const sumScore = await getSumScore(playerId);
  const numRank = await Promise.all(
    [1, 2, 3, 4].map(async (position) => getNumRank(playerId, position))
  );
  const numSeat = await Promise.all(
    [0, 1, 2, 3].map(async (seat) => getNumSeat(playerId, seat))
  );
  const numKyoku = await getNumKyoku(playerId);
  const numHora = await getNumHora(playerId);
  const numTsumo = await getNumTsumo(playerId);
  const numHouju = await getNumHouju(playerId);
  const numRyukyoku = await getNumRyukyoku(playerId);
  const numTenpai = await getNumTenpai(playerId);
  const numRiichi = await getNumRiichi(playerId);
  const numNaki = await getNumNaki(playerId);

  return {
    numGame,
    sumRank,
    sumScore,
    numRank,
    numSeat,
    numKyoku,
    numHora,
    numTsumo,
    numHouju,
    numRyukyoku,
    numTenpai,
    numRiichi,
    numNaki,
  };
});
