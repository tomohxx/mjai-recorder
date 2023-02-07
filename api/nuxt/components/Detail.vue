<template>
  <v-table>
    <template v-slot:default>
      <thead>
        <tr>
          <th class="text-left">項目</th>
          <th class="text-left">値</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="item in items" :key="item.name">
          <td>{{ item.name }}</td>
          <td>{{ item.value }}</td>
        </tr>
      </tbody>
    </template>
  </v-table>
</template>

<script setup lang="ts">
interface Props {
  stats: {
    numGame: number,
    sumRank: number,
    sumScore: number,
    numRank: number[],
    numSeat: number[],
    numKyoku: number,
    numHora: [number, number],
    numTsumo: number,
    numHouju: [number, number],
    numRyukyoku: number,
    numTenpai: number,
    numRiichi: number,
    numNaki: number,
  }
}

interface Item {
  name: string,
  value: string,
}

const props = defineProps<Props>();
const items = ref<Item[]>([]);

watch(() => props.stats, stats => {
  items.value = [
    {
      name: "試合数",
      value: stats.numGame.toString(),
    },
    {
      name: "平均順位",
      value: (stats.sumRank / stats.numGame).toFixed(2),
    },
    {
      name: "平均最終持ち点",
      value: (stats.sumScore / stats.numGame).toFixed(2),
    },
    {
      name: "一位率",
      value: (stats.numRank[0] / stats.numGame).toFixed(2),
    },
    {
      name: "二位率",
      value: (stats.numRank[1] / stats.numGame).toFixed(2),
    },
    {
      name: "三位率",
      value: (stats.numRank[2] / stats.numGame).toFixed(2),
    },
    {
      name: "四位率",
      value: (stats.numRank[3] / stats.numGame).toFixed(2),
    },
    {
      name: "東家率",
      value: (stats.numSeat[0] / stats.numGame).toFixed(2),
    },
    {
      name: "南家率",
      value: (stats.numSeat[1] / stats.numGame).toFixed(2),
    },
    {
      name: "西家率",
      value: (stats.numSeat[2] / stats.numGame).toFixed(2),
    },
    {
      name: "北家率",
      value: (stats.numSeat[3] / stats.numGame).toFixed(2),
    },
    {
      name: "局数",
      value: stats.numKyoku.toString(),
    },
    {
      name: "和了率",
      value: (stats.numHora[0] / stats.numKyoku).toFixed(4),
    },
    {
      name: "平均得点",
      value: (stats.numHora[1] / stats.numHora[0]).toFixed(2),
    },
    {
      name: "自摸率",
      value: (stats.numTsumo / stats.numKyoku).toFixed(4),
    },
    {
      name: "放銃率",
      value: (stats.numHouju[0] / stats.numKyoku).toFixed(4),
    },
    {
      name: "平均失点",
      value: (stats.numHouju[1] / stats.numHouju[0]).toFixed(2),
    },
    {
      name: "流局率",
      value: (stats.numRyukyoku / stats.numKyoku).toFixed(2),
    },
    {
      name: "聴牌率",
      value: (stats.numTenpai / stats.numKyoku).toFixed(2),
    },
    {
      name: "立直率",
      value: (stats.numRiichi / stats.numKyoku).toFixed(2),
    },
    {
      name: "副露率",
      value: (stats.numNaki / stats.numKyoku).toFixed(2),
    }
  ];
}, { immediate: true });
</script>
