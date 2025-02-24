<template>
  <div class="flex items-center justify-center min-h-screen bg-gray-100 dark:bg-gray-800">
    <div class="bg-white dark:bg-gray-700 p-8 rounded-lg shadow-md max-w-md w-full">
      <h2 class="text-2xl font-bold text-center mb-6 text-gray-900 dark:text-white">ลงชื่อเข้าใช้งาน ระบบสารสนเทศนักศึกษาคณะนิติศาสตร์</h2>
      <form @submit.prevent="handleLogin">
        <div class="mb-4">
          <label class="block text-sm font-semibold mb-2 text-gray-900 dark:text-white" for="username">Username</label>
          <input 
            type="text" 
            id="username" 
            v-model="username" 
            class="w-full border border-gray-300 dark:border-gray-600 p-2 rounded focus:outline-none focus:ring focus:ring-blue-300 dark:focus:ring-blue-500"
            required 
          />
        </div>
        <div class="mb-6">
          <label class="block text-sm font-semibold mb-2 text-gray-900 dark:text-white" for="password">Password</label>
          <input 
            type="password" 
            id="password" 
            v-model="password" 
            class="w-full border border-gray-300 dark:border-gray-600 p-2 rounded focus:outline-none focus:ring focus:ring-blue-300 dark:focus:ring-blue-500"
            required 
          />
        </div>
        <button 
          type="submit" 
          class="w-full bg-blue-500 text-white font-semibold p-2 rounded hover:bg-blue-600 dark:bg-blue-700 dark:hover:bg-blue-600"
        >
          Login
        </button>
        <p v-if="errorMessage" class="mt-4 bg-red-500 text-white font-bold text-center p-2 rounded dark:bg-red-700">
          {{ errorMessage }}
        </p>
      </form>
    </div>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  data() {
    return {
      username: '',
      password: '',
      errorMessage: '', // สำหรับแสดงข้อความผิดพลาด
    };
  },
  methods: {
    async handleLogin() {
      if (this.username === 'admin') {
        // ถ้า username เป็น admin ให้ส่ง request ไปยัง API ของ admin
        await this.handleAdminLogin();
      } else {
        // ถ้าไม่ใช่ admin ให้ส่ง request ไปยัง API ปกติ
        await this.handleRegularLogin();
      }
    },

    async handleAdminLogin() {
      const apiUrl = `${import.meta.env.VITE_APP_BASE_URL}/api/admin/login`;

      try {
        const response = await axios.post(apiUrl, {
          username: this.username,
          password: this.password,
        });

        const result = response.data;
        console.log('API Response:', result); // เพื่อดูว่ามีการตอบกลับที่ถูกต้องหรือไม่
        
        if (response.status === 200) {
          if (result.message === "Login successful") {
            localStorage.setItem('isAuthenticated', 'true');
            localStorage.setItem('userProfile', JSON.stringify(result.profile));
            console.log("++ result.profile=" + result.profile);

            const user = result.profile[0]; // ใช้ result.profile[0] เพื่อเข้าถึงข้อมูลผู้ใช้แรก
            const usertype = user.usertype; // ดึงค่า usertype จาก user

            // POST JSON username ไปยัง /api/dash/addlogged
            await this.addLoggedUser(this.username,usertype);

            const storedProfile = localStorage.getItem("userProfile");
            console.log("++ localStorage=" + storedProfile);
            this.$router.push('/admin/dashboard');  // เปลี่ยนเส้นทางไปหน้า Admin Dashboard
          } else {
            this.errorMessage = result.message || 'Login failed. Please try again.';
          }
        } else {
          this.errorMessage = 'Server error. Please try again later.';
        }

      } catch (error) {
        console.error('Error:', error);
        this.errorMessage = 'An error occurred. Please try again.';
      }
    },

    async addLoggedUser(username,usertype) {
      const apiLoggedUrl = `${import.meta.env.VITE_APP_BASE_URL}/api/dash/addlogged`;
      console.log("Sending username:", username);
      console.log("Sending usertype:", usertype);
      try {
        await axios.post(apiLoggedUrl, {
          username: username,
          usertype: usertype
        });
        console.log("Logged username added successfully.");
      } catch (error) {
        console.error('Error adding logged username:', error);
      }
    },

    async handleRegularLogin() {
      const authenUsername = this.username;
      const authenPassword = this.password;
      const authenSystem = "ACTIVITYRMU";
      const authenToken = "984130787a2f0d2899fc7b94eead168c";
      const apiUrl = `https://stndev.rmu.ac.th/authen/check-login.php?authen_username=${authenUsername}&authen_password=${authenPassword}&authen_system=${authenSystem}&authen_token=${authenToken}`;

      try {
        const response = await fetch(apiUrl, {
          method: 'GET',
        });

        const result = await response.json();

        console.log('API Response:', result);

        if (response.ok) {
          if (result.statusCode === 200 && result.message === "มีข้อมูลผู้ใช้ในระบบ") {
            const userProfile = result.profile;

            if (userProfile && Object.keys(userProfile).length > 0) {
              const userTypeName = userProfile.USERTYPENAME;
              const userFaculty = userProfile.FACULTYNAME;

              localStorage.setItem('userProfile', JSON.stringify(userProfile));
              localStorage.setItem('isAuthenticated', 'true');

              const USERTYPE = userProfile.USERTYPE;
              localStorage.setItem('USERTYPE', USERTYPE);

              console.log("usertype from login = " + USERTYPE);
              console.log("userTypeName = " + userTypeName);
              console.log("FACULTYNAME = " + userFaculty);

              if (userTypeName === "นักศึกษา") {
                await this.addLoggedUser(this.username,"student");
                this.$router.push('/subject');
                
              } else if (userTypeName === "สายสนับสนุน" || userTypeName === "สายวิชาการ") {
                await this.addLoggedUser(this.username,"teacher");
                this.$router.push('/teacher/dashboard');
              } else {
                this.errorMessage = 'ประเภทผู้ใช้นี้ไม่ถูกต้อง';
              }
            } else {
              this.errorMessage = 'ข้อมูลโปรไฟล์ไม่ถูกต้อง';
            }
          } else if (result.statusCode === 404 && result.message === "ไม่พบข้อมูลผู้ใช้ในระบบ") {
            this.errorMessage = "Username หรือ Password ไม่ถูกต้อง";
          } else {
            this.errorMessage = result.message || 'Login failed. Please try again.';
          }
        } else {
          this.errorMessage = 'Server error. Please try again later.';
        }
      } catch (error) {
        console.error('Error:', error);
        this.errorMessage = 'An error occurred. Please try again.';
      }
    },
  },
};
</script>

<style scoped>
/* เพิ่มสไตล์ที่คุณต้องการ */
</style>