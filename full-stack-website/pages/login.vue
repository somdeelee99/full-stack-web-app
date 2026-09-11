<template>
  <div class="card w-full max-w-md">
    <div class="flex items-center gap-3 mb-6">
      <div class="w-12 h-12 bg-primary rounded-xl flex items-center justify-center text-white">
        <Lock :size="24" />
      </div>
      <div>
        <h1 class="text-2xl font-bold">Admin Login</h1>
        <p class="text-xs text-gray-500">Zod + VeeValidate + Pinia + Toast</p>
      </div>
    </div>

    <form @submit.prevent="onSubmit" class="space-y-4">
      <div>
        <label class="text-sm font-medium flex items-center gap-2"><Mail :size="14" /> Email</label>
        <input v-model="email" class="input mt-1" placeholder="admin@laoshop.la" type="email" />
        <span v-if="errors.email" class="text-red-500 text-xs">{{ errors.email }}</span>
      </div>

      <div>
        <label class="text-sm font-medium flex items-center gap-2"><Key :size="14" /> Password</label>
        <input v-model="password" class="input mt-1" type="password" placeholder="••••••" />
        <span v-if="errors.password" class="text-red-500 text-xs">{{ errors.password }}</span>
      </div>

      <button :disabled="isSubmitting" class="btn-primary w-full py-3 flex items-center justify-center gap-2">
        <LogIn :size="18" />
        {{ isSubmitting ? 'ກຳລັງເຂົ້າ...' : 'ເຂົ້າສູ່ລະບົບ' }}
      </button>

      <div v-if="loginError" class="bg-red-50 text-red-600 p-3 rounded-xl text-sm flex items-center gap-2">
        <AlertCircle :size="16" /> {{ loginError }}
      </div>
    </form>

    <div class="mt-6 p-3 bg-gray-900 text-green-400 rounded-xl text-[11px]">
      <p class="text-gray-400">// Zod Schema:</p>
      <p>z.object({ email: z.string().email(), password: z.string().min(6) })</p>
    </div>
  </div>
</template>

<script setup lang="ts">
definePageMeta({ layout: 'auth' })

import { useForm } from 'vee-validate'
import { Lock, Mail, Key, LogIn, AlertCircle } from 'lucide-vue-next'
import { toast } from 'vue3-toastify'
import { loginFormSchema } from '~/composables/useProductSchema'

const auth = useAuthStore()
const loginError = ref('')

const { handleSubmit, errors, defineField, isSubmitting } = useForm({
  validationSchema: loginFormSchema
})

const [email] = defineField('email')
const [password] = defineField('password')

// default
email.value = 'admin@laoshop.la'
password.value = 'admin123'

const onSubmit = handleSubmit(async (values) => {
  loginError.value = ''
  try {
    const config = useRuntimeConfig()
    const data: any = await $fetch(`${config.public.apiBase}/auth/admin/login`, {
      method: 'POST',
      body: values
    })
    auth.setAuth(data.user, data.token)
    toast.success('ເຂົ້າສູ່ລະບົບສຳເລັດ 🎉')
    await navigateTo('/')
  } catch (e: any) {
    loginError.value = 'ອີເມວ ຫຼື ລະຫັດຜ່ານບໍ່ຖືກຕ້ອງ'
    toast.error('ເຂົ້າສູ່ລະບົບບໍ່ສຳເລັດ')
  }
})
</script>
