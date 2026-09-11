<template>
  <div class="p-8">
    <h1 class="text-2xl font-bold mb-6">ອໍເດີທັງໝົດ - Nuxt.js</h1>
    <div class="space-y-4">
      <div v-for="o in orders" :key="o.id" class="card">
        <div class="flex justify-between">
          <div>
            <p class="font-bold">{{ o.orderNumber }}</p>
            <p class="text-sm text-gray-500">{{ o.customer?.name }} • {{ o.customer?.email }} • {{ new Date(o.createdAt).toLocaleString() }}</p>
            <p class="text-sm mt-2">ທີ່ຢູ່: {{ o.shippingAddress || 'ບໍ່ມີ' }}</p>
            <div class="mt-2 flex gap-2 flex-wrap">
              <span v-for="it in o.items" :key="it.id" class="text-xs bg-gray-100 px-2 py-1 rounded-full">{{ it.product?.name }} x{{ it.quantity }}</span>
            </div>
          </div>
          <div class="text-right">
            <p class="text-xl font-bold text-primary">${{ o.totalAmount.toFixed(2) }}</p>
            <p :class="`text-xs px-3 py-1 rounded-full inline-block mt-1 ${statusClass(o.status)}`">{{ o.status }}</p>
            <select :value="o.status" @change="updateStatus(o.id, ($event.target as HTMLSelectElement).value)" class="input mt-2 text-sm">
              <option>PENDING</option><option>CONFIRMED</option><option>SHIPPING</option><option>DELIVERED</option><option>CANCELLED</option>
            </select>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
const { api } = useApi()
const orders = ref<any[]>([])

const load = async () => { orders.value = await api('/orders') as any }
await load()

const updateStatus = async (id: number, status: string) => {
  await api(`/orders/${id}/status`, { method: 'PUT', body: { status } })
  await load()
}

const statusClass = (s: string) => {
  if (s === 'PENDING') return 'bg-amber-100 text-amber-700'
  if (s === 'DELIVERED') return 'bg-green-100 text-green-700'
  return 'bg-blue-100 text-blue-700'
}
</script>
