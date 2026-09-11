import { defineStore } from 'pinia'

export const useAuthStore = defineStore('auth', {
  state: () => ({
    token: '' as string,
    user: null as any,
    isLoading: false
  }),
  getters: {
    isLoggedIn: (state) => !!state.token
  },
  actions: {
    init() {
      if (typeof window !== 'undefined') {
        this.token = localStorage.getItem('admin_token') || ''
      }
    },
    setAuth(user: any, token: string) {
      this.user = user
      this.token = token
      if (typeof window !== 'undefined') {
        localStorage.setItem('admin_token', token)
      }
    },
    logout() {
      this.token = ''
      this.user = null
      if (typeof window !== 'undefined') {
        localStorage.removeItem('admin_token')
      }
      navigateTo('/login')
    }
  }
})
