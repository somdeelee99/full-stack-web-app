export default defineNuxtConfig({
  devtools: { enabled: true },
  modules: [
    '@nuxtjs/tailwindcss',
    '@pinia/nuxt',
    '@nuxt/image'
  ],
  css: ['~/assets/css/main.css'],
  plugins: ['~/plugins/toast.client.ts'],
  app: {
    head: {
      title: 'LaoShop Admin - Full Packages',
      meta: [{ name: 'description', content: 'Nuxt 3 with 12 packages' }]
    }
  },
  runtimeConfig: {
    public: {
      apiBase: process.env.NUXT_PUBLIC_API_BASE || 'http://localhost:3001/api'
    }
  },
  ssr: false,
  image: {
    domains: ['picsum.photos', 'example.com']
  }
})
