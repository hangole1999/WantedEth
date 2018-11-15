
<template>
    <div class="wanted-eth">
        <h1>Welcome to the Wanted Ethereum</h1>
        <h4>Let's hunt wanted ethereum !</h4>
        <ul>
            <li>
                <button v-on:click='openPopup("registerPlayer")'>Register Player</button>
                </li>
            <li>
                <button v-on:click='openPopup("wantedEthereum")'>Wanted Ethereum Monster</button>
            </li>
            <li>
                <button v-on:click='openPopup("huntingEthereum")'>Hunting Ethereum Monster</button>
            </li>
        </ul>
    </div>
</template>

<script>
export default {
    name: 'WantedEth',
    data () {
        return {
            amount: null,
            pending: false,
            winEvent: null
        }
    },
    methods: {
        openPopup(target) {
            this.$parent.popup.show = target;
        },
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
    }
};
</script>
  
<style scoped>
</style>
