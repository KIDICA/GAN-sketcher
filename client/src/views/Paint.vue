<template>
  <div>
    <div class="row">
      <div class="col-2">
        <div class="card rounded-0 border-1">
          <div class="card-header rounded-0 p-2 text-white text-left bg-color-1 rounded-0">Pen</div>
          <div class="card-body p-0 bg-dark">
            <picker v-on:pick="select"></picker>
          </div>
          <div class="card-footer rounded-0 p-2" v-bind:style="`background-color: ${texture.color};`">
            <div v-bind:class="texture.text==='light'?'text-light':'text-dark'">
              Selection: <span v-text="texture.title"></span>
            </div>
          </div>
        </div>
      </div>

      <div class="col pl-0">
        <div class="card border-1 rounded-0 bg-dark">
          <div class="card-header p-2 text-white rounded-0 bg-color-2">Draw</div>
          <div class="card-body p-3">
            <div class="row text-left">
              <div class="col">
                <toolbar v-bind:button-list="buttons" class="mb-3" v-on:select="toolbarSelect"></toolbar>
              </div>
            </div>
            <div class="row">
              <div class="col-10 text-left">
                <painter ref="paint" v-on:mouseup="mouseUp" v-on:mousedown="mouseDown"></painter>
              </div>
              <div class="col">
                <pen-selector ref="penSelector" :color="penInfo.color" v-on:change="penChange"></pen-selector>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div class="col-1 m-0 p-0">
        <button class="btn btn-warning border-dark rounded-0 pl-0 pr-0 font-weight-bold" v-on:click="convert">
          <span style="font-size: 500%">
            &rarr;
          </span>
          Convert
        </button>
      </div>

      <div class="col">
        <div class="card border-1 h-100 rounded-0 bg-dark">
          <div class="card-header p-2 text-white rounded-0 bg-color-3">Image Synthesis</div>
          <div class="card-body p-3 d-flex h-100 mx-auto text-white">
            <h1 v-show="!image" class="w-100 justify-content-center align-self-center">No Image
              Yet.</h1>
            <img alt="Generated Image" v-show="image" class="border border-light justify-content-center align-self-center" :src="image" height="400" width="400"/>
            <busy ref="busy"></busy>
          </div>
        </div>
      </div>

    </div>
  </div>
</template>

<script>
import Picker from "../components/Picker";
import Painter from "../components/Painter";
import PenSelector from "../components/PenSelector";
import Toolbar from "../components/Toolbar";
import Busy from "../components/Busy";

export default {
  name: "paint",
  components: {
    "picker": Picker,
    "painter": Painter,
    "pen-selector": PenSelector,
    "toolbar": Toolbar,
    "busy": Busy,
  },
  data() {
    return {
      image: false,
      buttons: ["pen", "eraser", "eye-dropper", "fill-drip", "undo", "redo", "trash", ["Shape", "Circle", "Square"]],
      penInfo: { color: "black" },
      toolbar: { selection: "" },
      texture: { title: "None", color: "", text: "dark" },
      // draw,pick
      mode: "draw",
      // Beware that each item is pixel data stored in RAM (stored onmouseup).
      stack: {
        undo: [],
        redo: [],
      },
      snapshot: undefined,
    }
  },
  watch: {
    busy(val) {
      this.$refs.busy.work = val;
    },
  },
  methods: {
    select(texture) {
      this.texture = texture;
      this.$refs.paint.pen = texture.color;
      this.$refs.penSelector.color = texture.color;
    },
    pen() {
      this.$refs.paint.pen = this.texture.color;
      this.$refs.paint.mode = "draw";
      this.$log.info(this.$refs.paint.mode);
    },
    trash() {
      this.$refs.paint.clear();
    },
    undo() {
      if (this.stack.undo.length > 0) {
        const data = this.stack.undo.pop();
        this.stack.redo.push(data);
        this.$refs.paint.putData(data);
      }
    },
    redo() {
      if (this.stack.redo.length > 0) {
        const data = this.stack.redo.pop();
        this.stack.undo.push(data);
        this.$refs.paint.putData(data);
      }
    },
    eraser() {
      this.$refs.paint.pen = "white";
      this.$refs.paint.mode = "draw";
    },
    circle() {
      this.$refs.paint.shape = "circle";
      this.$refs.penSelector.shape = "circle";
    },
    square() {
      this.$refs.paint.shape = "square";
      this.$refs.penSelector.shape = "square";
    },
    filldrip() {
      this.$refs.paint.mode = "fill";
    },
    eyedropper() {
      this.mode = "pick";
    },
    toolbarSelect(selection) {
      const method = selection.toLowerCase().replace(/[^a-z]/g, "");
      this[method]();
    },
    penChange(val) {
      this.$refs.paint.radius = val;
    },
    mouseUp() {
      this.stack.undo.push(this.snapshot);
      this.stack.redo = [];
    },
    mouseDown() {
      this.snapshot = this.$refs.paint.getData();
    },
    convert() {
      this.busy = true;

      const dataURL = this.$refs.paint.toPNG();
      fetch("/upload", {
        method: "POST",
        body: dataURL,
      }).then(response => response.json())
        .then(r => {
          this.image = `${this.$baseUrl}${r.location}`;
          this.busy = false;
        });
    },
  },
};
</script>

<style scoped>
.bg-color-1 {
  background: #df3e73;
}

.bg-color-2 {
  background: #541c44;
}

.bg-color-3 {
  background: #a2549c;
}

.border-1 {
  border: 2px solid black;
}
</style>
