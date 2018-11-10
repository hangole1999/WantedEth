
<template>
  <div class='metamask-info'>
    <p v-if="isInjected" id="has-metamask"><i aria-hidden="true" class="fa fa-check"></i> Metamask installed</p>
    <p v-else id="no-metamask"><i aria-hidden="true" class="fa fa-times"></i> Metamask not found</p>
    <p>Network: {{network}}</p>
    <p>Account: {{coinbase}}</p>
    <p>Balance: {{numberWithCommas((parseInt(balance) / 1000000000000000000).toFixed(3))}} Ether ({{numberWithCommas((parseInt(balance) / 1000000000).toFixed(3))}} Gwei / {{numberWithCommas(balance)}} Wei)</p>
  </div>
</template>
  
<script>
import {NETWORKS} from '../util/networks';

export default {
  name: 'hello-metamask',
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
