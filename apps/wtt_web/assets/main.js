import Game from './vue/game.vue'
import App from './vue/app.vue'
import Vue from 'vue'
import VueRouter from 'vue-router'
import axios from 'axios'
import VueAxios from 'vue-axios'
import 'bootstrap'

import 'bootstrap/dist/css/bootstrap.min.css';

Vue.use(VueRouter)
Vue.use(VueAxios, axios)

const routes = [
    { path: '/game', component: Game }
]

const router = new VueRouter({
    mode: 'history',
    routes
})


new Vue({
    render: h => h(App),
    router,
    el: "#app"
})
