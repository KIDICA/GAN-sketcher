<template>
  <div>
    <canvas class="shadow-sm" ref="c" style="border:1px solid lightgray"
            v-bind:width="size.width"
            v-bind:height="size.height"
            v-on:touchstart="down"
            v-on:touchend="up"
            v-on:touchmove="move"
            v-on:touchcancel="up"
            v-on:mouseenter="enter"
            v-on:mousedown="down"
            v-on:mouseup="up"
            v-on:mousemove="move"
            v-on:mouseleave="leave">
    </canvas>
    <span
      ref="pointer"
      v-show="pointer.show"
      style="position: absolute; z-index: 1000; background: black; opacity: 0.1; width:50px; height:50px; border-radius: 100px;"></span>
  </div>
</template>

<script>
export default {
  props: {
    width: Number,
    height: Number,
  },
  data() {
    return {
      out: false,
      mouseDown: false,
      left: false,
      w: 0,
      h: 0,
      logicalWidth: 0,
      logicalHeight: 0,
      ctx: undefined,
      cardHeader: this.header || "Header",
      pen: "#ffffff",
      shape: "circle",
      radius: 10,
      pointer: {
        show: false,
        x: 0,
        y: 0,
      },
      size: {
        width: this.width || 400,
        height: this.height || 400,
      },
      // draw/fill
      mode: "draw",
    }
  },
  methods: {
    clear() {
      this.ctx.fillStyle = "#ffffff";
      this.ctx.fillRect(0, 0, this.w, this.h);
      this.$emit("clear");
    },
    drawShape(x, y, radius) {
      this.ctx.beginPath();
      this.ctx.fillStyle = this.pen;
      const r = radius || this.radius;

      switch (this.shape) {
        case "circle":
          this.ctx.arc(x, y, r, 0, 2 * Math.PI, false);
          break;
        case "square":
          this.ctx.rect(x - r, y - r, r * 2, r * 2);
          break;
      }

      this.ctx.fill();
      this.ctx.closePath();
    },
    /**
     * @param {number} x
     * @param {number} y
     * @param {string} color
     */
    putPixel(x, y, color) {
      this.ctx.fillStyle = color || this.pen;
      this.ctx.fillRect(x, y, 1, 1);
    },
    cart_coord(e) {
      const rect = this.$refs.c.getBoundingClientRect();

      return {
        x: parseInt(e.clientX - rect.left),
        y: parseInt(e.clientY - rect.top),
      };
    },
    getPixel(x, y) {
      const offset = y * this.w * 4 + x * 4;
      const data = this.getData().data;
      return [data[offset], data[offset + 1], data[offset + 2], data[offset + 3]];
    },
    hexToRGB(hex) {
      let c;
      if (/^#([A-Fa-f0-9]{3}){1,2}$/.test(hex)) {
        c = hex.substring(1).split("");
        if (c.length === 3) {
          c = [c[0], c[0], c[1], c[1], c[2], c[2]];
        }
        c = "0x" + c.join("");
        return [(c >> 16) & 255, (c >> 8) & 255, c & 255]
      }
      throw new Error("Bad Hex");
    },
    /**
     * The elegant version of this flood fill algorithm is recursive,
     * I rewrote it to an iterative version for performance reasons.
     */
    floodFill(startX, startY, penColor, startColor) {
      const imageData = this.getData();
      const data = imageData.data;
      const stack = [startX, startY];

      while (stack.length > 0) {
        const y = stack.pop();
        const x = stack.pop();

        const outOfBounds = y < 0 || y > this.h - 1 || x < 0 || x > this.w - 1;
        if (outOfBounds) {
          continue;
        }

        const offset = y * this.w * 4 + x * 4;
        const colorXY = [data[offset], data[offset + 1], data[offset + 2]];

        const hasAlreadyFillColor = colorXY[0] === penColor[0] && colorXY[1] === penColor[1] && colorXY[2] === penColor[2];
        const hasStartColor = colorXY[0] === startColor[0] && colorXY[1] === startColor[1] && colorXY[2] === startColor[2];

        if (hasStartColor && !hasAlreadyFillColor) {
          data[offset] = penColor[0];
          data[offset + 1] = penColor[1];
          data[offset + 2] = penColor[2];

          // vertical
          stack.push(x);
          stack.push(y - 1);

          stack.push(x);
          stack.push(y + 1);

          // horizontal
          stack.push(x + 1);
          stack.push(y);

          stack.push(x - 1);
          stack.push(y);

          // diagonal
          stack.push(x + 1);
          stack.push(y + 1);

          stack.push(x - 1);
          stack.push(y - 1);

          stack.push(x - 1);
          stack.push(y + 1);

          stack.push(x + 1);
          stack.push(y - 1);

        }
      }

      this.putData(imageData);
    },

    // Dynamically dispatched.
    fillMode(event) {
      const c = this.cart_coord(event);
      console.log(c.x, c.y, this.w * 4 * c.y + 4 * c.x);
      this.floodFill(c.x, c.y, this.hexToRGB(this.pen), this.getPixel(c.x, c.y));
    },
    // Dynamically dispatched.
    drawMode(event) {
      const c = this.cart_coord(event);
      this.drawShape(c.x, c.y);
    },

    down(event) {
      this.mouseDown = true;
      this.modeFn(event);
      this.$emit("mousedown");
    },
    up() {
      this.mouseDown = false;
      this.$emit("mouseup");
    },
    /**
     * Delegates the call based on this.mode
     * @param args all args are delegated.
     */
    modeFn(...args) {
      return this[this.mode + "Mode"](...args);
    },
    move(event) {
      if (this.mode === "draw" && this.withinCanvas === false && this.mouseDown) {
        this.modeFn(event);
        // Pointer
        //this.$refs.pointer.style.left = c.x + 90 + "px";
        //this.$refs.pointer.style.top = c.y + 25 + "px";
      }
    },
    enter() {
      this.withinCanvas = false;
    },
    leave() {
      this.withinCanvas = true;
    },
    /** @returns {Uint8ClampedArray} */
    getData() {
      return this.ctx.getImageData(0, 0, this.w, this.h);
    },
    putData(data) {
      this.ctx.putImageData(data, 0, 0);
    },
    getCanvas() {
      return this.$refs.c;
    },
    toJPG(q = 0.8) {
      return this.$refs.c.toDataURL("image/jpeg", q);
    },
    toPNG() {
      return this.$refs.c.toDataURL("image/png");
    },
  },
  mounted() {
    this.ctx = this.$refs.c.getContext("2d");
    this.ctx.imageSmoothingEnabled = false;

    this.w = this.$refs.c.width;
    this.h = this.$refs.c.height;

    this.clear();
  },
}
</script>

<style scoped>

</style>
