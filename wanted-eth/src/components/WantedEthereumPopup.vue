
<template>
  <transition name="popup">
    <div class="wanted-ethereum popup-mask">
      <div class="popup-wrapper">
        <div class="popup-container">

          <div class="popup-header">
            <slot name="header">
              <label>Wanted Ethereum Monster</label>
              <button class="popup-close-button" @click="$emit('close')">X</button>
            </slot>
          </div>

          <div class="popup-body">
            <slot name="body">
              <div class="wanted-poster">
                <h1>W A N T E D</h1>
                <div class="image-wrapper">
                  <img :src="imageUrl"/>
                </div>
                <p>Name : {{monsterNameString}}</p>
                <p>{{rewardEthString}} Rewarded</p>
              </div>
              <div class="input-field">
                <label>Etereum Monster Name</label>
                <input id="monster_name" name="monster_name" type="text" v-model="monsterName"/>
              </div>
              <div class="input-field">
                <label>Reward Eth (wei)</label>
                <input id="monster_name" name="monster_name" type="number" v-model="rewardEth"/>
              </div>
            </slot>
          </div>

          <div class="popup-footer">
            <slot name="footer">
              <button class="popup-accept-button" @click="wanted">Wanted</button>
            </slot>
          </div>
        </div>
      </div>
    </div>
  </transition>
</template>

<script>
export default {
  name: 'WantedEthereumPopup',
  data() {
    return {
      monsterName: '',
      rewardEth: 0
    };
  },
  computed: {
    imageUrl() {
      return 'https://picsum.photos/g/300/200/?random&blur&s=' + this.getSlug();
    },
    monsterNameString() {
      return this.monsterName == '' ? 'Unkown' : this.monsterName;
    }, 
    computedRewardEth() {
      if (this.rewardEth > BigInt(1000000000000000000000)) {
        this.rewardEth = BigInt(1000000000000000000000);
      }
      return this.rewardEth;
    }, 
    rewardEthString() {
	    var value = BigInt(this.computedRewardEth);
      var unit = 'wei';
      var gwei = BigInt(1000000000);
      var eth = BigInt(1000000000000000000);
      if (value >= eth) {
        value /= eth;
        unit = 'eth';
      } else if (value >= gwei) {
        value /= gwei;
        unit = 'gwei';
      }
      return value.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",") + ' ' + unit;
    } 
  },
  methods: {
    wanted() {

    },
    getSlug() {
      var max = 90000;
      var min = 10000;
      var slug = Math.random() * (max - min) + min;
      return slug;
    }
  },
  created() {
    console.log("WantedEthereumPopup.created()");
  }
}
</script>
