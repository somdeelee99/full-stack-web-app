/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ['./components/**/*.{js,vue,ts}', './layouts/**/*.vue', './pages/**/*.vue', './plugins/**/*.{js,ts}', './app.vue'],
  theme: {
    extend: {
      colors: {
        primary: { DEFAULT: '#6C5CE7', light: '#a29bfe', dark: '#4834d4' },
        secondary: '#00CEC9'
      }
    }
  }
}
