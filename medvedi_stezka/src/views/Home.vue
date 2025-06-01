<template>
  <div class="home">
    <h1>Welcome to the Home Page</h1>
    <p>This is a simple Vue 3 + TypeScript view component.</p>
    <button @click="increment">Count: {{ count }}</button>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'

const count = ref(0)

function increment() {
  count.value++
}
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
