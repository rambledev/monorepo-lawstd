import { defineConfig } from 'vite';
import vue from '@vitejs/plugin-vue';

export default defineConfig({
  plugins: [vue()],
  server: {
    cors: true,  // เปิดใช้งาน CORS สำหรับ dev server
  },
  build: {
    // กำหนดค่าสำหรับ production
  }
});
