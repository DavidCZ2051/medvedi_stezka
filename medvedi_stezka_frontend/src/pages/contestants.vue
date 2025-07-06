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

        <v-dialog v-model="dialog" max-width="500">
            <v-card>
                <v-form @submit.prevent="createContestant">
                    <v-card-title>Vytvořit nového soutěžícího</v-card-title>
                    <v-card-text>
                        <v-text-field
                            v-model="formData.birthYear"
                            label="Rok narození"
                            :rules="[v => !!v || 'Rok narození je povinný']"
                            required
                        ></v-text-field>
                        <v-text-field
                            v-model="formData.name.first"
                            label="Jméno"
                            :rules="[v => !!v || 'Jméno je povinné']"
                            required
                        ></v-text-field>
                        <v-text-field
                            v-model="formData.name.middle"
                            label="Druhé jméno (volitelné)"
                        ></v-text-field>
                        <v-text-field
                            v-model="formData.name.last"
                            label="Příjmení"
                            :rules="[v => !!v || 'Příjmení je povinné']"
                            required
                        ></v-text-field>
                    </v-card-text>
                    <v-card-actions>
                        <v-spacer></v-spacer>
                        <v-btn text @click="dialog = false">Zrušit</v-btn>
                        <v-btn type="submit" color="primary">Vytvořit</v-btn>
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
    birthYear: 0,
    name: {
        first: '',
        middle: '',
        last: ''
    }
})

watch(dialog, (newValue) => {
    if (!newValue) {
        formData.value = { birthYear: 0, name: { first: '', middle: '', last: '' } }
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
    const response = await fetch(`${instance.appContext.config.globalProperties.$url}/contestants`, {
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

    await fetchContestants()
    dialog.value = false
}

</script>

<route lang="yaml">
meta:
    layout: nav
</route>