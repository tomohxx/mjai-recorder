<template>
  <v-app>
    <v-main>
      <v-container>
        <h1>Mjai Recorder</h1>
        <div class="mb-2">
          <a href="/storage/">牌譜</a>
        </div>
        <v-select
          :items="items"
          label="プレイヤー名"
          v-model="select"
          item-text="player_name"
        ></v-select>
        <v-row>
          <v-col cols="6">
            <Record
              v-if="select"
              :labels="labelsGame"
              :api="apiGame"/>
          </v-col>
          <v-col cols="6">
            <Record
              v-if="select"
              :labels="labelsKyoku"
              :api="apiKyoku"/>
          </v-col>
        </v-row>
      </v-container>
    </v-main>
  </v-app>
</template>

<script>
import Record from './components/Record'

export default {
  name: 'App',

  components: {
    Record,
  },

  data() {
    return {
      select: null,
      items: [],
      labelsGame: {
        num_games: "試合数",
        avg_ranking: "平均順位",
        avg_final_score: "平均最終持ち点",
        rate_first: "1位率",
        rate_second: "2位率",
        rate_third: "3位率",
        rate_fourth: "4位率",
        rate_east: "東家率",
        rate_south: "南家率",
        rate_west: "西家率",
        rate_north: "北家率",
      },
      labelsKyoku: {
        num_kyoku: "局数",
        rate_hora: "和了率",
        rate_tsumo: "自摸率",
        rate_houju: "放銃率",
        avg_score: "平均得点",
        avg_loss: "平均失点",
        rate_riichi: "立直率",
        rate_naki: "副露率",
        rate_ryukyoku: "流局率",
        rate_tenpai: "聴牌率",
      }
    }
  },
  mounted () {
    this.axios
      .get("/api/player_list")
      .then(response => {
        this.items = response.data
      })
  },
  computed: {
    apiGame: function () {
      return "/api/rpc/stat_game?arg=" + this.select
    },
    apiKyoku: function () {
      return "/api/rpc/stat_kyoku?arg=" + this.select
    }
  },
};
</script>

<style>
#app {
  font-family: "Noto Sans JP", sans-serif;
}
</style>
