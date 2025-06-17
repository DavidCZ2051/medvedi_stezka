<template>
    <v-container>
        <v-row>
            <v-col cols="12">
                <v-card>
                    <v-card-text>
                        <v-list>
                            <v-list-item v-for="competition in competitions" :key="competition.id">
                                <v-list-item-content>
                                    <v-list-item-title>{{ competition.location }}</v-list-item-title>
                                    <v-list-item-subtitle>{{ competition.schoolYear }}</v-list-item-subtitle>
                                    <v-list-item-subtitle>{{ competition.type }}</v-list-item-subtitle>
                                </v-list-item-content>
                            </v-list-item>
                        </v-list>
                    </v-card-text>
                </v-card>
            </v-col>
        </v-row>
    </v-container>
</template>

<script lang="ts" setup>
import { ref, getCurrentInstance } from 'vue'
import type { Ref } from 'vue'
import { useRouter } from 'vue-router'

const instance = getCurrentInstance()!
const router = useRouter()

const competitions: Ref<Array<{ id: string; location: string; schoolYear: string; type: string }>> = ref([])

onMounted(async () => {
    const response = await fetch(`${instance.appContext.config.globalProperties.$url}/competitions`, {
        method: 'GET',
        headers: {
            'Authorization': `Bearer ${localStorage.getItem('token')}`
        }
    })

    if (!response.ok) {
        alert('Failed to fetch competitions: ' + response.statusText)
        return
    }

    competitions.value = await response.json()
})

</script>
