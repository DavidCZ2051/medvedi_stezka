<template>
    <v-app-bar :elevation="0">
        <v-toolbar-title>Soutěž</v-toolbar-title>
        <v-spacer />
        <p class="mr-4">{{ getNickname() }}</p>
        <v-btn icon @click="logout" title="Odhlásit se">
            <v-icon>mdi-logout</v-icon>
        </v-btn>
    </v-app-bar>
    <v-navigation-drawer>
        <v-list-item link title="Soutěž" prepend-icon="mdi-trophy"></v-list-item>
        <v-list-item link title="Kontroly" prepend-icon="mdi-clipboard-text"></v-list-item>
        <v-list-item link title="Týmy" prepend-icon="mdi-account-group"></v-list-item>
        <v-list-item link title="Kartičky" prepend-icon="mdi-card-account-details"></v-list-item>
    </v-navigation-drawer>
</template>

<script lang="ts" setup>
import { useRouter } from 'vue-router'
import { getNickname } from '@/utils/auth'

const router = useRouter()

function logout() {
    localStorage.removeItem('token')
    router.push('/login')
}

</script>