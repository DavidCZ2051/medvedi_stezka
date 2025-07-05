<template>
  <v-container class="text-center">
    <v-progress-circular indeterminate color="primary" />
    <p>Přesměrovávání...</p>
  </v-container>
</template>


<script lang="ts" setup>
import { useRouter } from 'vue-router'

const router = useRouter()

router.replace('/')
</script>
