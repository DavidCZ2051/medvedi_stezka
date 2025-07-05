<template>
  <v-container>
    <h1 class="text-center">Vítejte {{ getNickname() }}</h1>
  </v-container>
</template>

<script lang="ts" setup>
import { getNickname } from '@/utils/auth'
</script>

<route lang="yaml">
meta:
  layout: nav
</route>
