<template>
    <v-container>
        <v-row>
            <v-col cols="12">
                <v-btn @click="dialog = true">Vytvořit novou hlídku</v-btn>
            </v-col>
        </v-row>

        <v-dialog v-model="dialog" max-width="700">
            <v-card>
                <v-form @submit.prevent="createTeam">
                    <v-card-title class="text-h6 font-weight-bold">
                        Vytvořit novou hlídku
                    </v-card-title>

                    <v-card-text>
                        <v-container class="pa-0" fluid>
                            <v-row dense>
                                <v-col cols="6">
                                    <v-text-field v-model="formData.name.first" label="Jméno"
                                        placeholder="Druhé jméno odělte mezerou" prepend-icon="mdi-account"
                                        :rules="[v => !!v || 'Jméno je povinné']" required />
                                </v-col>
                                <v-col cols="6">
                                    <v-text-field v-model="formData.name.last" label="Příjmení"
                                        :rules="[v => !!v || 'Příjmení je povinné']" required />
                                </v-col>
                                <v-col cols="12">
                                    <v-text-field v-model="formData.birthYear" label="Rok narození"
                                        prepend-icon="mdi-calendar" placeholder="YYYY" :rules="[
                                            v => !!v || 'Rok narození je povinný',
                                            v => /^\d{4}$/.test(v) || 'Rok narození musí být ve formátu YYYY'
                                        ]" required />
                                </v-col>
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
    await fetchTeams()
})

const instance = getCurrentInstance()!
const router = useRouter()

const teams: Ref<Array<{ id: string,  }>> = ref([])

const dialog = ref(false)
const formData = ref({
   
})

watch(dialog, (newValue) => {
    if (!newValue) {
        formData.value = { birthYear: '', name: { first: '', last: '' } }
    }
})

async function fetchTeams() {
    const response = await fetch(`${instance.appContext.config.globalProperties.$url}/teams`, {
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
        alert('Failed to fetch teams: ' + response.statusText)
        return
    }

    teams.value = await response.json()
}


async function createTeam() {
    const response = await fetch(`${instance.appContext.config.globalProperties.$url}/teams`, {
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
        alert('Failed to create team: ' + response.statusText)
        return
    }

    //await fetchTeams()
    dialog.value = false
}

</script>

<route lang="yaml">
meta:
    layout: nav
</route>