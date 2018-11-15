
<template>
  <div class='metamask-info'>
    <p v-if="!isInjected" id="no-metamask" class="cr">Can't read Ethereum Wallet</p>
    <div v-if="isInjected">
      <p>{{network}}</p>
      <p>{{coinbase}}</p>
      <p>{{numberWithCommas((parseInt(balance) / 1000000000000000000).toFixed(3))}} Ether ({{numberWithCommas((parseInt(balance) / 1000000000).toFixed(3))}} Gwei / {{numberWithCommas(balance)}} Wei)</p>
    </div>
  </div>
</template>
  
<script>
import {NETWORKS} from '../util/networks';

export default {
  name: 'HelloMetamask',
  methods: {
    numberWithCommas(x) {
      return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    }
  },
  computed: {
    isInjected: state => state.web3.isInjected,
    network: state => NETWORKS[state.web3.networkId],
    coinbase: state => state.web3.coinbase,
    balance: state => state.web3.balance,
    web3 () {
      return this.$store.state.web3;
    }
  }
};
</script>
  
<style scoped>
</style>
