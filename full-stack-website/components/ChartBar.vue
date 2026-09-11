<template>
  <Bar :data="chartData" :options="chartOptions" />
</template>

<script setup lang="ts">
import { Bar } from 'vue-chartjs'
import { Chart as ChartJS, Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale } from 'chart.js'
import dayjs from 'dayjs'

ChartJS.register(Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale)

const props = defineProps<{ data?: number[], labels?: string[] }>()

const chartData = computed(() => ({
  labels: props.labels || ['ຈັນ', 'ອັງຄານ', 'ພຸດ', 'ພະຫັດ', 'ສຸກ', 'ເສົາ', 'ທິດ'].map((d, i) => dayjs().subtract(6 - i, 'day').format('DD/MM')),
  datasets: [{
    label: 'ຍອດຂາຍ ($)',
    data: props.data || [120, 190, 300, 500, 200, 300, 450],
    backgroundColor: '#6C5CE7',
    borderRadius: 10,
    borderSkipped: false
  }]
}))

const chartOptions = {
  responsive: true,
  plugins: { legend: { display: false } },
  scales: { y: { beginAtZero: true } }
}
</script>
