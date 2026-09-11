<template>
  <div class="p-8">
    <h1 class="text-2xl font-bold mb-6">ລູກຄ້າ - Nuxt.js</h1>
    <div class="flex gap-8">
      <div class="flex-1 space-y-3">
        <div v-for="c in customers" :key="c.id" @click="selectCustomer(c.id)" :class="`card cursor-pointer hover:shadow-md transition ${selected?.id===c.id ? 'ring-2 ring-primary' : ''}`">
          <div class="flex items-center gap-3">
            <div class="w-10 h-10 bg-gradient-to-br from-primary to-secondary rounded-full flex items-center justify-center text-white font-bold">{{ c.name[0] }}</div>
            <div><p class="font-bold">{{ c.name }}</p><p class="text-xs text-gray-500">{{ c.email }} • {{ c.phone }}</p></div>
          </div>
        </div>
      </div>

      <div v-if="selected" class="w-96 card h-fit sticky top-8">
        <h3 class="font-bold text-lg">{{ selected.name }}</h3>
        <p class="text-sm text-gray-500">{{ selected.email }}</p>
        <p class="text-sm text-gray-500">{{ selected.phone }}</p>
        <p class="text-sm mt-4"><b>ທີ່ຢູ່:</b> {{ selected.address || 'ບໍ່ມີ' }}</p>
        <p v-if="selected.latitude" class="text-sm"><b>Location:</b> {{ selected.latitude }}, {{ selected.longitude }}</p>
        <p class="text-sm mt-2"><b>ສ້າງບັນຊີ:</b> {{ new Date(selected.createdAt).toLocaleDateString() }}</p>
        <div class="mt-6">
          <p class="font-bold mb-2">ປະຫວັດສັ່ງຊື້ ({{ selected.orders?.length || 0 }})</p>
          <div v-for="o in selected.orders" :key="o.id" class="text-xs bg-gray-50 p-2 rounded-lg mb-2 flex justify-between">
            <span>{{ o.orderNumber }} - {{ o.status }}</span><span class="font-bold">${{ o.totalAmount }}</span>
          </div>
        </div>
        <button @click="selected = null" class="btn-secondary w-full mt-4">ປິດ</button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
const { api } = useApi()
const customers = ref<any[]>([])
const selected = ref<any>(null)

const load = async () => { customers.value = await api('/customers') as any }
await load()

const selectCustomer = async (id: number) => {
  selected.value = await api(`/customers/${id}`) as any
}
</script>
