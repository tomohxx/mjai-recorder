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
    numKyoku: number,
  }
}

const { stats } = defineProps<Props>();

const items = ref([
  {
    name: "試合数",
    value: stats.numGame,
  },
  {
    name: "局数",
    value: stats.numKyoku,
  }
]);
</script>
