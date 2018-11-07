import Vue from 'vue';
import Router from 'vue-router';
import WantedEthDapp from '../App';

Vue.use(Router);

export default new Router({
  mode: 'history',
  routes: [
    {
      path: '/',
      name: 'wanted-eth-dapp',
      component: WantedEthDapp
    }
  ]
});
