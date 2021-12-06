<template>
  <div>
    <dl>
      <v-row class="mt-0" v-for="item in items" :key="item.key">
        <th class="col-6 text-left">{{ labels[item.key] }}</th>
        <td class="col-6 text-left">{{ item.value }}</td>
      </v-row>
    </dl>
  </div>
</template>

<script>
export default {
  name: "Record",

  props: {
    labels: Object,
    api: String
  },
  data() {
    return {
      items: [],
    }
  },
  watch: {
    api: {
      handler: function () {
        this.items = []
        this.axios
          .get(this.api)
          .then(response => {
            const data = response.data[0]

            for (const key in data) {
              this.items.push({key: key, value: data[key]})
            }
          })
      },
      immediate: true
    }
  }
}
</script>
