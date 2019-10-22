<template>
  <div>
    <button
      v-for="texture in textures"
      v-bind:style="'background-color:'+texture.color"
      class="btn w-50 btn-default rounded-0 border-dark shadow-sm float-left"
      v-bind:class="texture.text==='light' ? 'text-white' : 'text-dark'"
      v-on:click="pick(texture)" v-text="texture.title"></button>
  </div>
</template>

<script>
export default {
  name: "Picker",
  data() {
    return {
      textures: [
        { color: "#384f83", title: "sea", text: "light" },
        { color: "#efefef", title: "cloud", text: "dark" },
        { color: "#2c1e16", title: "dirt", text: "light" },
        { color: "#5d6e32", title: "bush", text: "light" },
        { color: "#b7d24e", title: "grass", text: "dark" },
        { color: "#3c3b4b", title: "mountain", text: "light" },
        { color: "#987e6a", title: "road", text: "light" },
        { color: "#759edf", title: "sky-other", text: "light" },
        { color: "#352613", title: "tree", text: "light" },
        { color: "#636363", title: "pavement", text: "light" },
        { color: "#e670b6", title: "flower", text: "dark" },
        { color: "#c1c3c9", title: "fog", text: "dark" },
        { color: "#776c2d", title: "hill", text: "light" },
        { color: "#bf602c", title: "leaves", text: "light" },
        { color: "#32604d", title: "river", text: "light" },
        { color: "#fafafa", title: "snow", text: "dark" },
        { color: "#7CFC00", title: "airplane", text: "dark" },
        { color: "#D2D2D2", title: "boat", text: "dark" },
        { color: "#D2691E", title: "bridge", text: "light" },
        { color: "#8B0000", title: "roof*", text: "light" },
        { color: "#DEB887", title: "house*", text: "dark" },
        { color: "#00CED1", title: "window", text: "dark" },
        { color: "#B22222", title: "wall-brick*", text: "light" },
        { color: "#8B4513", title: "branch", text: "light" },
        // { color: "#FF3232", title: "fire" }
      ],
    }
  },
  methods: {
    /**
     * @param {{color:String, title:String}} texture
     */
    pick(texture) {
      this.$emit("pick", texture);
    },
  },
}
</script>

<style scoped>

</style>
