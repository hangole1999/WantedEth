
<template lang="html">
  <div id="app">
    <hello-metamask/>
    <WantedEth/>
  </div>
</template>

<script>
import HelloMetamask from './components/hello-metamask.vue';
import WantedEth from './components/wanted-eth-component.vue';
export default {
  name: 'wanted-eth-dapp',
  beforeCreate () {
    console.log('registerWeb3 Action dispatched from wanted-eth-dapp.vue');
    this.$store.dispatch('registerWeb3');
  },
  data () {
    return {
      msg: 'Welcome to Your Vue.js App'
    };
  },
  components: { 
    HelloMetamask,
    WantedEth
  }
};
</script>

<style>
#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}

h1, h2 {
  font-weight: normal;
}

ul {
  list-style-type: none;
  padding: 0;
}

li {
  display: inline-block;
  margin: 0 10px;
}

a {
  color: #42b983;
}
</style>
