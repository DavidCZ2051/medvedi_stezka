<template>
    <v-app-bar :elevation="0">
        <v-toolbar-title>Domov</v-toolbar-title>
        <v-spacer />
        <p class="mr-4">{{ getNickname() }}</p>
        <v-btn icon @click="logout" title="Odhlásit se">
            <v-icon>mdi-logout</v-icon>
        </v-btn>
    </v-app-bar>
    <v-navigation-drawer>
        <v-list-item link title="Soutěže" prepend-icon="mdi-trophy" :to="'competitions'"></v-list-item>
        <v-list-item link title="Jednoty" prepend-icon="mdi-domain" :to="'organizations'"></v-list-item>
        <v-list-item link title="Soutěžící" prepend-icon="mdi-account-group" :to="'contestants'"></v-list-item>
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