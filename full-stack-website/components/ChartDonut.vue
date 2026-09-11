<template>
  <Doughnut :data="chartData" :options="chartOptions" />
</template>

<script setup lang="ts">
import { Doughnut } from 'vue-chartjs'
import { Chart as ChartJS, ArcElement, Tooltip, Legend } from 'chart.js'

ChartJS.register(ArcElement, Tooltip, Legend)

const chartData = {
  labels: ['ເສື້ອຜ້າ', 'ເອເລັກໂທນິກ', 'ອາຫານ', 'ອື່ນໆ'],
  datasets: [{
    data: [35, 25, 22, 18],
    backgroundColor: ['#6C5CE7', '#00CEC9', '#FDCB6E', '#E17055']
  }]
}

const chartOptions = {
  responsive: true,
  plugins: { legend: { position: 'bottom' as const } }
}
</script>
