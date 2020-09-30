import VueApp from './vue/app.vue'
import Vue from 'vue'
import 'bootstrap'

Vue.component('app', VueApp)

new Vue({
    render: h => h(VueApp)
}).$mount('#app')