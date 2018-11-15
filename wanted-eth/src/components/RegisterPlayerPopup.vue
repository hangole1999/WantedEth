
<template>
  <transition name="popup">
    <div class="register-player popup-mask">
      <div class="popup-wrapper">
        <div class="popup-container">

          <div class="popup-header">
            <slot name="header">
              <label>Register Player</label>
              <button class="popup-close-button" @click="$emit('close')">X</button>
            </slot>
          </div>

          <div class="popup-body">
            <slot name="body">
              <div class="image-wrapper">
                <img class="hunter" src="../assets/hunter.jpg"/>
              </div>
              <div class="input-field">
                <label>Player Name</label>
                <input id="player_name" name="player_name" type="text"/>
              </div>
            </slot>
          </div>

          <div class="popup-footer">
            <slot name="footer">
              <button class="popup-accept-button" @click="register">Register</button>
            </slot>
          </div>
        </div>
      </div>
    </div>
  </transition>
</template>

<script>
export default {
  name: 'RegisterPlayerPopup',
  methods: {
    register() {

    }
  },
  created() {
    console.log("RegisterPlayerPopup.created()");
  }
}
</script>
