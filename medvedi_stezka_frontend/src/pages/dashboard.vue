<template>
    <v-app-bar>
        <v-toolbar-title>Medvědí stezka</v-toolbar-title>
    </v-app-bar>
    <v-navigation-drawer>
        <v-list-item
            link
            title="Soutěže"
            prepend-icon="mdi-trophy"
        ></v-list-item>
        <v-list-item
            link
            title="Organizace"
            prepend-icon="mdi-domain"
        ></v-list-item>
        <v-list-item
            link
            title="Soutěžící"
            prepend-icon="mdi-account-group"
        ></v-list-item>
    </v-navigation-drawer>
    <Competitions></Competitions>
</template>

<script lang="ts" setup>
import { ref, getCurrentInstance } from 'vue'
import { useRouter } from 'vue-router'

const instance = getCurrentInstance()!
const router = useRouter()

const selectedPage = ref("competitions")

</script>
