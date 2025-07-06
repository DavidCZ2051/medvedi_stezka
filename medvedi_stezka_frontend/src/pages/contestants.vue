<template>
    <v-container>
        <v-row>
            <v-col cols="12">
                <v-btn @click="dialog = true">Vytvořit nového soutěžícího</v-btn>
            </v-col>
            <v-data-table :items="contestants" :headers="headers">
                <template #item.name.first="{ item }">
                    {{ item.name.first }}{{ item.name.middle ? ' ' + item.name.middle : '' }}
                </template>
            </v-data-table>
        </v-row>

        <v-dialog v-model="dialog" max-width="700">
            <v-card>
                <v-form @submit.prevent="createContestant">
                    <v-card-title class="text-h6 font-weight-bold">
                        Vytvořit nového soutěžícího
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
                                        prepend-icon="mdi-calendar" :rules="[
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

const dialog = ref(false)
const formData = ref({
    birthYear: '',
    name: {
        first: '',
        last: ''
    }
})

watch(dialog, (newValue) => {
    if (!newValue) {
        formData.value = { birthYear: '', name: { first: '', last: '' } }
    }
})

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


async function createContestant() {
    const nameParts = formData.value.name.first.split(' ')
    const firstName = nameParts[0]
    const middleName = nameParts.length > 1 ? nameParts.slice(1).join(' ') : null

    const response = await fetch(`${instance.appContext.config.globalProperties.$url}/contestants`, {
        method: 'POST',
        headers: {
            'Authorization': `Bearer ${localStorage.getItem('token')}`,
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            'birthYear': +formData.value.birthYear,
            'name': {
                'first': firstName,
                'middle': middleName?.trim() || null,
                'last': formData.value.name.last
            }
        })
    })

    if (!response.ok) {
        if (response.status === 401) {
            localStorage.removeItem('token')
            router.replace('/login')
            return
        }
        alert('Failed to create contestant: ' + response.statusText)
        return
    }

    await fetchContestants()
    dialog.value = false
}

</script>

<route lang="yaml">
meta:
    layout: nav
</route>