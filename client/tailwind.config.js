/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './src/Components/*.{html,js}',
    './src/*.{html,js}'
  ],
  theme: {
    extend: {
      backgroundColor:{
        'black-t-50': 'rgba(0,0,0,0.5)'
      }
    },
  },
  plugins: [],
}

