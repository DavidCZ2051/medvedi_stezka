<template>
  <div class="test">
    <h1>Welcome to the Test Page</h1>
    <HelloWorld msg="Hello from Test Page!" />
  </div>
</template>

<script setup lang="ts">
import HelloWorld from '../components/HelloWorld.vue'

</script>

<style scoped>
.home {
  padding: 1rem;
  text-align: center;
}
button {
  margin-top: 1rem;
  padding: 0.5rem 1rem;
  font-size: 1rem;
}
</style>
