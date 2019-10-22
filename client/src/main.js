import Vue from "vue";
import App from "./App.vue";
import router from "./router";
import "./registerServiceWorker";
import {library} from "@fortawesome/fontawesome-svg-core"
import {
  faPen,
  faEraser,
  faUndo,
  faRedo,
  faTrash,
  faFillDrip,
  faEyeDropper,
  faPalette
} from "@fortawesome/free-solid-svg-icons"
import {FontAwesomeIcon} from "@fortawesome/vue-fontawesome"

Vue.config.productionTip = false;

library.add(faPen, faEraser, faUndo, faRedo, faTrash, faFillDrip, faEyeDropper, faPalette);

Vue.prototype.$log = {
  info(...args) {
    console.log(...args);
  },
  error(...args) {
    console.error(...args);
  },
  debug(...args) {
    console.debug(...args);
  },
};

Vue.prototype.$baseUrl = window.location.origin + "/";

Vue.component("font-awesome-icon", FontAwesomeIcon);

new Vue({
  router,
  render: h => h(App),
}).$mount("#app");
