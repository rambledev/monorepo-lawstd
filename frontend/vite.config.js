import { defineConfig } from 'vite';
import vue from '@vitejs/plugin-vue';

export default defineConfig({
  plugins: [vue()],
  server: {
    cors: true,  // เปิดใช้งาน CORS สำหรับ dev server
  },
  build: {
    outDir: 'dist',  // กำหนดโฟลเดอร์ที่จะเก็บไฟล์ build
    sourcemap: true, // สร้าง sourcemap สำหรับการ debug (สามารถปิดได้ถ้าไม่ต้องการ)
    rollupOptions: {
      // เพิ่มการตั้งค่า Rollup หากต้องการ
    }
  }
});