<template>
  <div class="pen-container">
    <div class="mb-4 pen-preview" v-bind:style="`height: ${radius*2}px; width:${radius*2}px;border-radius: ${radius}px;background-color:${color};border-radius:${shape==='circle'?radius*2:0}px;`"></div>
    <input class="pen-slider" v-model="radius" type="range" min="5" max="30" v-on:change="$emit('change', radius)" orient="vertical">
  </div>
</template>

<script>
export default {
  data() {
    return {
      color: "black",
      radius: 10,
      shape: "circle",
    };
  },
  watch:  {
    radius(val) {
      console.log(val);
    }
  }
}
</script>

<style scoped>
.pen-preview {
  margin: auto;
  width: 50%;
}

.pen-slider {
  margin: auto;
  width: 50%;
}

input[type=range][orient=vertical] {
  writing-mode: bt-lr; /* IE */
  -webkit-appearance: slider-vertical; /* WebKit */
  height: 175px;
  padding: 0 5px;
}
</style>
