<template>
  <v-app>
    <v-main>
      <v-container>
        <h1>Mjai Recorder</h1>
        <v-btn href="/storage/">牌譜</v-btn>
        <v-select :items="players || []" label="プレイヤー名" item-title="playerName" item-value="id" v-model="select"
          item-text="player_name" />
        <Detail v-if="stats" :stats="stats" />
      </v-container>
    </v-main>
  </v-app>
</template>

<script setup lang="ts">
const { data: players } = await useFetch("/api/players");
const select = ref("");
const { data: stats } = await useFetch("/api/stats",
  {
    query:
      { playerId: select },
    watch: [select],
    immediate: false,
  });
</script>
