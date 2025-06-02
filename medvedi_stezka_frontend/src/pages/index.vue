<template>
  <v-container fill-height>
    <v-row align="center" justify="center">
      <v-progress-circular indeterminate color="primary" />
    </v-row>
  </v-container>
</template>

<script setup lang="ts">
import { onMounted, getCurrentInstance } from 'vue'
import { useRouter } from 'vue-router'

const { appContext } = getCurrentInstance()!
const url = appContext.config.globalProperties.$url

const router = useRouter()

onMounted(async () => {
  const token = localStorage.getItem('token')
  if (!token) {
    router.replace('/login')
    return
  }

  try {
    const response = await fetch(`${url}/auth/validate`, {
      method: 'GET',
      headers: {
        'Authorization': `Bearer ${token}`
      }
    })

    if (response.ok) {
      router.replace('/dashboard')
    } else {
      localStorage.removeItem('token')
      router.replace('/login')
    }
  } catch (err) {
    console.error('Token validation failed:', err)
    localStorage.removeItem('token')
    router.replace('/login')
  }
})
</script>
