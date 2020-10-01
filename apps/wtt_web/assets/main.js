import Game from './vue/game.vue'
import Vue from 'vue'
import axios from 'axios'
import VueAxios from 'vue-axios'
import 'bootstrap'

import './styles/main.scss'
import 'bootstrap/dist/css/bootstrap.min.css';

Vue.use(VueAxios, axios)

new Vue({
    render: h => h(Game),
    el: "#app"
})
