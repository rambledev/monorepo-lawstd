/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./index.html",
    "./src/**/*.{vue,js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        primary: '#1D4ED8',
        success: '#22C55E',
        warning: '#eab308',
        danger: '#dc2626',
      },
      fontFamily: {
        sans: ['Prompt', 'sans-serif'], // เพิ่มฟอนต์ Prompt
      },
    },
  },
  plugins: [],
}
