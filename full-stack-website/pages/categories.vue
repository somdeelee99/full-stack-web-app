<template>
  <div class="p-8">
    <h1 class="text-2xl font-bold mb-6">ໝວດໝູ່ - Nuxt.js</h1>
    <div class="flex gap-8">
      <div class="card w-80 h-fit">
        <h3 class="font-bold mb-4">ເພີ່ມໝວດໝູ່</h3>
        <input v-model="name" class="input mb-3" placeholder="ຊື່ໝວດໝູ່" />
        <input v-model="desc" class="input mb-3" placeholder="ຄຳອະທິບາຍ" />
        <button @click="addCategory" class="btn-primary w-full">ເພີ່ມ</button>
        <div class="mt-4 bg-green-50 p-3 rounded-xl text-xs">
          <p class="font-bold">Vue 3 Composition API:</p>
          <code>const name = ref('')</code>
        </div>
      </div>
      <div class="flex-1 grid grid-cols-3 gap-4">
        <div v-for="c in categories" :key="c.id" class="card">
          <p class="font-bold">{{ c.name }}</p>
          <p class="text-sm text-gray-500">{{ c.description }}</p>
          <p class="text-xs mt-2 text-gray-400">{{ c._count?.products || 0 }} ສິນຄ້າ</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
const { api } = useApi()
const name = ref('')
const desc = ref('')
const categories = ref<any[]>([])

const load = async () => { categories.value = await api('/categories') as any }
await load()

const addCategory = async () => {
  if (!name.value) return
  await api('/categories', { method: 'POST', body: { name: name.value, description: desc.value, image: `https://picsum.photos/seed/cat${Date.now()}/200` } })
  name.value = ''
  desc.value = ''
  await load()
}
</script>
