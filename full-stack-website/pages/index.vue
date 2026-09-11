<template>
  <div class="p-8">
    <div class="flex justify-between items-center mb-8">
      <div>
        <h1 class="text-3xl font-bold flex items-center gap-3">
          <LayoutDashboard class="text-primary" /> Dashboard
        </h1>
        <p class="text-gray-500 flex items-center gap-2 mt-1">
          <Calendar :size="14" /> {{ today }} - ພາບລວມຮ້ານຄ້າ Full Packages
        </p>
      </div>
      <div class="flex gap-2">
        <span class="bg-primary text-white px-3 py-1 rounded-full text-xs flex items-center gap-1"><Package :size="12" /> Pinia</span>
        <span class="bg-green-500 text-white px-3 py-1 rounded-full text-xs">Zod</span>
        <span class="bg-orange-500 text-white px-3 py-1 rounded-full text-xs">Chart.js</span>
      </div>
    </div>

    <div class="grid grid-cols-4 gap-6 mb-8">
      <div v-for="card in cards" :key="card.label" class="card flex items-center gap-4">
        <div :class="`w-12 h-12 ${card.color} rounded-xl flex items-center justify-center text-white`">
          <component :is="card.icon" :size="20" />
        </div>
        <div>
          <p class="text-gray-500 text-sm">{{ card.label }}</p>
          <p class="text-2xl font-bold">{{ card.value }}</p>
        </div>
      </div>
    </div>

    <div class="grid grid-cols-3 gap-6">
      <div class="col-span-2 card">
        <h3 class="font-bold mb-4 flex items-center gap-2"><BarChart3 :size="18" /> ຍອດຂາຍ 7 ມື້ - Chart.js + Dayjs</h3>
        <ChartBar />
        <p class="text-xs text-gray-400 mt-2">ໃຊ້ dayjs() ສ້າງ label: {{ dayjs().format('DD/MM/YYYY') }}</p>
      </div>

      <div class="card">
        <h3 class="font-bold mb-4 flex items-center gap-2"><PieChart :size="18" /> ໝວດໝູ່ຂາຍດີ</h3>
        <ChartDonut />
      </div>
    </div>

    <div class="grid grid-cols-2 gap-6 mt-6">
      <div class="card">
        <h3 class="font-bold mb-3 flex items-center gap-2"><Image :size="18" /> @nuxt/image - ຮູບພາບ</h3>
        <div class="flex gap-3">
          <NuxtImg src="https://picsum.photos/200/200" width="80" height="80" class="rounded-xl" format="webp" />
          <NuxtImg src="https://picsum.photos/200/201" width="80" height="80" class="rounded-xl" format="webp" />
          <NuxtImg src="https://picsum.photos/200/202" width="80" height="80" class="rounded-xl" format="webp" />
        </div>
        <p class="text-xs text-gray-500 mt-2">NuxtImg ໂຫຼດໄວ, ບີບອັດຮູບອັດຕະໂນມັດ (webp)</p>
      </div>

      <div class="card">
        <h3 class="font-bold mb-3 flex items-center gap-2"><Bell :size="18" /> vue3-toastify</h3>
        <div class="flex gap-2">
          <button @click="toast.success('ສຳເລັດ!')" class="btn-primary text-sm">Success Toast</button>
          <button @click="toast.error('ເກີດຂໍ້ຜິດພາດ')" class="bg-red-500 text-white px-4 py-2 rounded-xl text-sm">Error Toast</button>
        </div>
        <p class="text-xs text-gray-500 mt-3">ໃຊ້ toast.success() / toast.error() ແຈ້ງເຕືອນງາມໆ</p>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { LayoutDashboard, Package, Users, ShoppingCart, Calendar, BarChart3, PieChart, Image, Bell } from 'lucide-vue-next'
import { toast } from 'vue3-toastify'
import dayjs from 'dayjs'

const auth = useAuthStore()
const { api } = useApi()

onMounted(() => {
  auth.init()
  if (!auth.token) navigateTo('/login')
})

const today = dayjs().format('DD/MM/YYYY HH:mm')

const { data } = await useAsyncData('dashboard', async () => {
  try {
    const [products, customers, orders] = await Promise.all([
      api('/products') as any,
      api('/customers') as any,
      api('/orders') as any,
    ])
    const revenue = orders.reduce((s: number, o: any) => s + o.totalAmount, 0)
    return { products: products.length, customers: customers.length, orders: orders.length, revenue }
  } catch {
    return { products: 0, customers: 0, orders: 0, revenue: 0 }
  }
})

const cards = computed(() => [
  { label: 'ສິນຄ້າທັງໝົດ', value: data.value?.products || 0, icon: Package, color: 'bg-violet-500' },
  { label: 'ລູກຄ້າ', value: data.value?.customers || 0, icon: Users, color: 'bg-cyan-500' },
  { label: 'ອໍເດີ', value: data.value?.orders || 0, icon: ShoppingCart, color: 'bg-amber-500' },
  { label: 'ລາຍໄດ້', value: `$${(data.value?.revenue || 0).toFixed(2)}`, icon: BarChart3, color: 'bg-emerald-500' },
])
</script>
