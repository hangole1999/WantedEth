
<template lang="html">
  <div id="app">
    <div class="background"></div>
    <hello-metamask/>
    <WantedEth/>
    <RegisterPlayerPopup v-if="showRegisterPlayerPopup" @close="popup.show = ''"/>
    <WantedEthereumPopup v-if="showWantedEthereumPopup" @close="popup.show = ''"/>
    <HuntingEthereumPopup v-if="showHuntingEthereumPopup" @close="popup.show = ''"/>
  </div>
</template>

<script>
import HelloMetamask from './components/HelloMetamask.vue';
import WantedEth from './components/WantedEthComponent.vue';
import RegisterPlayerPopup from './components/RegisterPlayerPopup.vue';
import WantedEthereumPopup from './components/WantedEthereumPopup.vue';
import HuntingEthereumPopup from './components/HuntingEthereumPopup.vue';

export default {
  name: 'WantedEthDApp',
  components: { 
    HelloMetamask,
    WantedEth,
    RegisterPlayerPopup,
    WantedEthereumPopup,
    HuntingEthereumPopup
  },
  data () {
    return {
      popup: {
        show: ''
      }
    };
  },
  computed: {
    showRegisterPlayerPopup() {
      return this.popup.show == 'registerPlayer';
    },
    showWantedEthereumPopup() {
      return this.popup.show == 'wantedEthereum';
    },
    showHuntingEthereumPopup() {
      return this.popup.show == 'huntingEthereum';
    }
  },
  beforeCreate () {
    console.log('registerWeb3 Action dispatched from wanted-eth-dapp.vue');
    this.$store.dispatch('registerWeb3');
  }
};
</script>

<style>
@import "assets/css/styles.css";
</style>
