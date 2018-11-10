
<template>
    <div class="casino">
        <h1>Welcome to the Wanted Ethereum</h1>
        <h4>Let's hunt wanted ethereum !</h4>
        <ul>
            <li v-on:click='registerPlayer'>Register Player</li>
            <li v-on:click='wantedEthereum'>Wanted Ethereum</li>
            <li v-on:click='huntingEthereum'>Hunting Ethereum</li>
        </ul>
    </div>
</template>

<script>
export default {
    name: 'wanted-eth',
    data () {
        return {
            amount: null,
            pending: false,
            winEvent: null
        }
    },
    methods: {
        registerPlayer(event) {
            console.log('registerPlayer()');
        },
        wantedEthereum(event) {
            console.log('wantedEthereum()');
        },
        huntingEthereum(event) {
            console.log('huntingEthereum()');
        }
        // clickNumber (event) {
        //     console.log(event.target.innerHTML, this.amount)
        //     this.winEvent = null
        //     this.pending = true
        //     this.$store.state.contractInstance().bet(event.target.innerHTML, {
        //         gas: 300000,
        //         value: this.$store.state.web3.web3Instance().toWei(this.amount, 'ether'),
        //         from: this.$store.state.web3.coinbase
        //     }, (err, result) => {
        //         if (err) {
        //             console.log(err)
        //             this.pending = false
        //         } else {
        //             let bettingResult = this.$store.state.contractInstance().bettingResult()
        //             /* .watch => solidity event를 감시 */
        //             bettingResult.watch((err, result) => {
        //                 if (err) {
        //                     console.log('could not get event Won()')
        //                 } else {
        //                     this.winEvent = result.args
        //                     this.winEvent.rewards = parseInt(result.args.rewards, 10)
        //                     console.log(`winEvent: ${result.args}`)
        //                     this.pending = false
        //                 }
        //             });
        //         }
        //     });
        // }
    },
    mounted () {
        console.log('dispatching getContractInstance');
        this.$store.dispatch('getContractInstance');
    },
    actions: {
        async getContractInstance({ commit }) {
            try {
                let result = await getContract;
                commit('registerContractInstance', result);
            } catch (err) {
                console.log('error in action getContractInstance', err);
            }
        }
    },
    mutation: {
        registerContractInstance(state, payload) {
            console.log('Wanted Ethereum contract instance: ', payload);
            state.contractInstance = () => payload;
        }
    }
};
</script>
  
<style scoped>
</style>
