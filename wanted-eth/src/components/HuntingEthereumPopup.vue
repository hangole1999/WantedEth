
<template>
  <transition name="popup">
    <div class="hunting-ethereum popup-mask">
      <div class="popup-wrapper">
        <div class="popup-container">

          <div class="popup-header">
            <slot name="header">
              <label>Hunting Ethereum Monster</label>
              <button class="popup-close-button" @click="$emit('close')">X</button>
            </slot>
          </div>

          <div class="popup-body">
            <slot name="body">
              <div class="image-wrapper">
                <img :src="imageUrl"/>
              </div>
              <div class="input-field">
                <label>Target Monster Name</label>
                <input id="target_name" name="target_name" type="text"/>
              </div>
              <div class="input-field">
                <label>Hunting Eth</label>
                <input id="monster_name" name="monster_name" type="number"/>
              </div>
            </slot>
          </div>

          <div class="popup-footer">
            <slot name="footer">
              <button class="popup-accept-button" @click="hunting">Hunting</button>
            </slot>
          </div>
        </div>
      </div>
    </div>
  </transition>
</template>

<script>
export default {
  name: 'HuntingEthereumPopup',
  computed: {
    imageUrl() {
      return 'https://picsum.photos/g/300/200/?random&blur&s=' + this.getSlug();
    }
  },
  methods: {
    hunting() {

    },
    getSlug() {
      var max = 90000;
      var min = 10000;
      var slug = Math.random() * (max - min) + min;
      return slug;
    }
  },
  created() {
    console.log("HuntingEthereumPopup.created()");
  }
}
</script>
