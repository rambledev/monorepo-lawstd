import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

export default defineConfig({
  plugins: [vue()],
  base: '/', // สำคัญ: ตั้งค่า base เป็น /
  build: {
    outDir: 'dist', // โฟลเดอร์ที่ build output จะถูกสร้าง (ค่า default คือ dist อยู่แล้ว)
  },
})