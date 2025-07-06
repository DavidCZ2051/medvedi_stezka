<template>
    <v-container>
        <v-row>
            <v-col cols="12">
                <v-btn @click="dialog = true">Vytvořit novou soutěž</v-btn>
            </v-col>
            <v-col v-for="competition in competitions" :key="competition.id" cols="12">
                <v-card :to="`/competition/${competition.id}`" link class="pb-4">
                    <v-card-title>{{ competition.location }}</v-card-title>
                    <v-card-subtitle>{{ competition.schoolYear }}</v-card-subtitle>
                    <v-card-subtitle>{{ competitionTypes[competition.type] }}</v-card-subtitle>
                </v-card>
            </v-col>
        </v-row>

        <v-dialog v-model="dialog" max-width="700">
            <v-card>
                <v-form @submit.prevent="createCompetition">
                    <v-card-title class="text-h6 font-weight-bold">
                        Vytvořit novou soutěž
                    </v-card-title>

                    <v-card-text>
                        <v-container class="pa-0" fluid>
                            <v-row dense>
                                <v-col cols="12">
                                    <v-text-field v-model="formData.location" label="Místo konání"
                                        prepend-icon="mdi-map-marker" :rules="[v => !!v || 'Místo konání je povinné']"
                                        required />
                                </v-col>
                                <v-col cols="12">
                                    <v-text-field v-model="formData.schoolYear" label="Školní rok"
                                        prepend-icon="mdi-calendar" placeholder="YYYY/YYYY"
                                        :rules="[v => !!v || 'Školní rok je povinný', v => /^\d{4}\/\d{4}$/.test(v) || 'Školní rok musí být ve formátu YYYY/YYYY']"
                                        required />
                                </v-col>
                                <v-col cols="12">
                                    <v-select v-model="formData.type" :items="Object.keys(competitionTypes)"
                                        :item-title="key => competitionTypes[key]" :item-value="key => key"
                                        label="Druh kola" prepend-icon="mdi-trophy"
                                        :rules="[v => !!v || 'Druh kola je povinný']" required />
                                </v-col>
                                <!-- <v-btn-toggle
                            v-model="formData.type"
                            color="primary"
                            mandatory
                            >
                            <v-btn value="district">Okresní kolo</v-btn>
                            <v-btn value="region">Krajské kolo</v-btn>
                            <v-btn value="nation">Republikové kolo</v-btn>
                        </v-btn-toggle> -->
                            </v-row>
                        </v-container>
                    </v-card-text>

                    <v-card-actions class="justify-end">
                        <v-btn variant="text" @click="dialog = false" color="grey-darken-1">
                            Zrušit
                        </v-btn>
                        <v-btn type="submit" color="primary" variant="elevated">
                            Vytvořit
                        </v-btn>
                    </v-card-actions>
                </v-form>
            </v-card>
        </v-dialog>
    </v-container>
</template>

<script lang="ts" setup>
import { ref, getCurrentInstance } from 'vue'
import type { Ref } from 'vue'
import { useRouter } from 'vue-router'

onMounted(async () => {
    await fetchCompetitions()
})

const instance = getCurrentInstance()!
const router = useRouter()

const competitions: Ref<Array<{ id: string, location: string, schoolYear: string, type: string }>> = ref([])
const competitionTypes: Record<string, string> = {
    'district': 'Okresní kolo',
    'region': 'Krajské kolo',
    'nation': 'Republikové kolo',
}

const dialog = ref(false)
const formData = ref({
    location: '',
    schoolYear: '',
    type: ''
})

watch(dialog, (newValue) => {
    if (!newValue) {
        formData.value = { location: '', schoolYear: '', type: '' }
    }
})

async function fetchCompetitions() {
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
}

async function createCompetition() {
    const response = await fetch(`${instance.appContext.config.globalProperties.$url}/competitions`, {
        method: 'POST',
        headers: {
            'Authorization': `Bearer ${localStorage.getItem('token')}`,
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(formData.value)
    })

    if (!response.ok) {
        if (response.status === 401) {
            localStorage.removeItem('token')
            router.replace('/login')
            return
        }
        alert('Failed to create competition: ' + response.statusText)
        return
    }

    await fetchCompetitions()
    dialog.value = false
}

</script>

<route lang="yaml">
meta:
  layout: nav
</route>
