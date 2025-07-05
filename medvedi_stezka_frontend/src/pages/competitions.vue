<template>
    <v-container>
        <v-row>
            <v-col
                v-for="competition in competitions"
                :key="competition.id"
                cols="12"
            >
                <v-card :to="`/competition/${competition.id}`" link class="pb-4">
                    <v-card-title>{{ competition.location }}</v-card-title>
                    <v-card-subtitle>{{ competition.schoolYear }}</v-card-subtitle>
                    <v-card-subtitle>{{ competitionTypes[competition.type] }}</v-card-subtitle>
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

const competitionTypes: Record<string, string> = {
    'district': 'Okresní kolo',
    'region': 'Krajské kolo',
    'nation': 'Republikové kolo',
}

onMounted(async () => {
    const response = await fetch(`${instance.appContext.config.globalProperties.$url}/competitions`, {
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
        alert('Failed to fetch competitions: ' + response.statusText)
        return
    }

    competitions.value = await response.json()
})

</script>

<route lang="yaml">
meta:
  layout: nav
</route>
