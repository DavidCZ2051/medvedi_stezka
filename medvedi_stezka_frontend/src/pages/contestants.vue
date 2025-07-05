<template>
    <v-container>
        <v-row>
            <v-col cols="12">
                <v-btn @click="">Vytvořit nového soutěžícího</v-btn>
            </v-col>
            <v-data-table :items="contestants" :headers="headers">
                <template #item.name.first="{ item }">
                    {{ item.name.first }}{{ item.name.middle ? ' ' + item.name.middle : '' }}
                </template>
            </v-data-table>
        </v-row>
    </v-container>
</template>

<script lang="ts" setup>
import { ref, getCurrentInstance } from 'vue'
import type { Ref } from 'vue'
import { useRouter } from 'vue-router'

onMounted(async () => {
    await fetchContestants()
})

const instance = getCurrentInstance()!
const router = useRouter()

const contestants: Ref<Array<{ id: string, birthYear: number, name: { first: string, middle: string | null, last: string } }>> = ref([])
const headers = [
    { title: 'Jméno', value: 'name.first' },
    { title: 'Příjmení', value: 'name.last' },
    { title: 'Rok narození', value: 'birthYear' }
]

async function fetchContestants() {
    const response = await fetch(`${instance.appContext.config.globalProperties.$url}/contestants`, {
        method: 'GET',
        headers: {
            'Authorization': `Bearer ${localStorage.getItem('token')}`
        }
    })

    if (!response.ok) {
        if (response.status === 401) {
            localStorage.removeItem('token')
            router.replace('/login')
            return
        }
        alert('Failed to fetch contestants: ' + response.statusText)
        return
    }

    contestants.value = await response.json()
}
</script>

<route lang="yaml">
meta:
    layout: nav
</route>