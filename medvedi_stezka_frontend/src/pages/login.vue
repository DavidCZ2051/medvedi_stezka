<template>
    <v-container class="d-flex align-center justify-center" style="min-height: 100vh;" fluid>
        <v-row align="center" justify="center" class="fill-height">
            <v-col cols="12" sm="8" md="4">
                <v-card>
                    <v-card-title class="text-h5">Přihlášení</v-card-title>
                    <v-card-text>
                        <v-form ref="form" @submit.prevent="login">
                            <v-text-field
                                v-model="username"
                                label="Uživatelské jméno"
                                :error-messages="usernameError"
                                class="mb-1"
                                required
                            />
                            <v-text-field
                                v-model="password"
                                label="Heslo"
                                :type="showPassword ? 'text' : 'password'"
                                :append-icon="showPassword ? 'mdi-eye-off' : 'mdi-eye'"
                                @click:append="showPassword = !showPassword"
                                :error-messages="passwordError"
                                class="mb-1"
                                required
                            />
                            <div class="d-flex align-center" style="margin-top: -16px; margin-bottom: -8px;">
                                <v-checkbox
                                    v-model="rememberMe"
                                    label="Zapamatovat si mě"
                                    class="ma-0 pa-0"
                                />
                            </div>
                            <v-btn type="submit" color="primary" block>Přihlásit se</v-btn>
                        </v-form>
                    </v-card-text>
                </v-card>
            </v-col>
        </v-row>
    </v-container>
</template>

<script lang="ts" setup>
import { ref, getCurrentInstance } from 'vue'
import { useRouter } from 'vue-router'

const instance = getCurrentInstance()!
const router = useRouter()

const username = ref('')
const password = ref('')
const showPassword = ref(false)
const rememberMe = ref(false)

const usernameError = ref('')
const passwordError = ref('')

async function login() {
    usernameError.value = ''
    passwordError.value = ''

    const result = await fetch(`${instance.appContext.config.globalProperties.$url}/auth/login`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            username: username.value,
            password: password.value,
            rememberMe: rememberMe.value
        })
    })

    if (result.status === 401) {
        const error = (await result.json()).error
        if (error === "Incorrect username") {
            usernameError.value = 'Nesprávné uživatelské jméno'
        } else if (error === "Incorrect password") {
            passwordError.value = 'Nesprávné heslo'
        }
    } else if (result.ok) {
        const data = await result.json()
        localStorage.setItem('token', data.token)
        router.replace('/')
    }
} 

</script>