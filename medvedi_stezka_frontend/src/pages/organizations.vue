<template>
    <v-container>
        <v-row>
            <v-col cols="12">
                <v-btn @click="dialog = true">Vytvořit novou organizaci</v-btn>
            </v-col>
            <v-col v-for="organization in organizations" :key="organization.name" cols="12" class="py-1">
                <v-card>
                    <v-card-title>{{ organization.name }}</v-card-title>
                </v-card>
            </v-col>
        </v-row>

        <v-dialog v-model="dialog" max-width="500">
            <v-card>
                <v-form @submit.prevent="createOrganization">
                    <v-card-title class="text-h6 font-weight-bold">
                        Vytvořit novou organizaci
                    </v-card-title>

                    <v-card-text>
                        <v-container class="pa-0" fluid>
                            <v-row dense>
                                <v-col cols="12">
                                    <v-text-field v-model="formData.name" label="Název organizace"
                                        prepend-icon="mdi-domain" :rules="[v => !!v || 'Název organizace je povinný']"
                                        required />
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
    await fetchOrganizations()
})

const instance = getCurrentInstance()!
const router = useRouter()

const organizations: Ref<Array<{ name: string }>> = ref([])

const dialog = ref(false)
const formData = ref({
    name: ''
})

watch(dialog, (newValue) => {
    if (!newValue) {
        formData.value = { name: '' }
    }
})

async function fetchOrganizations() {
    const response = await fetch(`${instance.appContext.config.globalProperties.$url}/organizations`, {
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
        alert('Failed to fetch organizations: ' + response.statusText)
        return
    }

    organizations.value = await response.json()
}

async function createOrganization() {
    const response = await fetch(`${instance.appContext.config.globalProperties.$url}/organizations`, {
        method: 'POST',
        headers: {
            'Authorization': `Bearer ${localStorage.getItem('token')}`,
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            'name': formData.value.name
        })
    })

    if (!response.ok) {
        if (response.status === 401) {
            localStorage.removeItem('token')
            router.replace('/login')
            return
        }
        alert('Failed to create organization: ' + response.statusText)
        return
    }

    await fetchOrganizations()
    dialog.value = false
}

</script>

<route lang="yaml">
meta:
    layout: nav
</route>
