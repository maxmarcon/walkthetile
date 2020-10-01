import VueApp from './vue/app.vue'
import Vue from 'vue'
import 'bootstrap'
import 'bootstrap/dist/css/bootstrap.min.css';

Vue.component('app', VueApp)

new Vue({
    render: h => h(VueApp),
    el: "#app"
})
