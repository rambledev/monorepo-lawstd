<template>
  <div id="app" :class="{ 'dark': isDarkMode }" class="flex-col items-center justify-center min-h-screen">
    <header class="mb-1">
      <h1 class="text-4xl font-bold">LAWSTD Admin</h1>
    </header>

    <div v-if="userProfile && userProfile.USERFULLNAME" class="user-profile-container">
      <label class="font-bold user-label">
        ผู้ใช้งาน : {{ userProfile.USERFULLNAME }}
      </label>
    </div>

    <nav class="nav-container mb-4">
      <div class="nav-left">
        <router-link class="mx-4 " to="/admin/dashboard">Dashboard</router-link>
        <router-link class="mx-4 " to="/admin/subject">จัดการรายวิชา</router-link>
        <router-link class="mx-4 " to="/admin/doc">เอกสาร</router-link>
        <router-link class="mx-4 " to="/admin/vdo">VDO</router-link>
        <router-link class="mx-4 " to="/admin/permission">กำหนดสิทธิ์รายวิชา</router-link>
        <router-link class="mx-4 " to="/admin/news">ข่าวหน้าแรก</router-link>
        <router-link class="mx-4 " to="/admin/links">ลิ้งค์หน้าแรก</router-link>
      </div>
      <div class="nav-right">
        
          <button @click="logout" class="logout-button bg-blue-400 text-white p-2 m-2">
            <i class="fas fa-sign-out-alt"></i> Logout
          </button>
      
      </div>
    </nav>

    <div class="card">
      <router-view />
    </div>
  </div>
</template>

<script>
export default {
  name: "AdminLayout",
  data() {
    return {
      userProfile: null, // ตัวแปรสำหรับเก็บข้อมูลผู้ใช้
      isDarkMode: false, // ตัวแปรสำหรับตรวจสอบ dark mode
    };
  },
  created() {
    this.checkAuthentication();
    this.checkDarkMode();
  },
  methods: {
    logout() {
      localStorage.removeItem("userProfile");
      localStorage.removeItem("isAuthenticated"); // ล้าง status ของการล็อกอิน
      this.isAuthen = false; // อัปเดต trạng tháiใน component

      this.$router.push("/login"); // เปลี่ยนเส้นทางไปที่หน้า Login
    },
    checkAuthentication() {
      const isAuthenticated = localStorage.getItem("isAuthenticated") === "true";
      console.log("checkAuthen = "+isAuthenticated);
      if (!isAuthenticated) {
        this.$router.push("/login"); // เปลี่ยนเส้นทางไปยังหน้า Login ถ้าไม่ได้ล็อกอิน
      }
    },
    loadUserProfile() {
      const storedProfile = localStorage.getItem("userProfile");
      console.log("profile logged = "+storedProfile);
      if (storedProfile) {
        //this.userProfile = JSON.parse(storedProfile); // แปลงข้อมูลที่เก็บใน localStorage เป็น object
        this.userProfile = storedProfile;
      }
    },
    checkDarkMode() {
      const storedDarkMode = localStorage.getItem("darkMode");
      if (storedDarkMode) {
        this.isDarkMode = storedDarkMode === "true";
      } else if (window.matchMedia && window.matchMedia("(prefers-color-scheme: dark)").matches) {
        this.isDarkMode = true;
      }
    },
    toggleDarkMode() {
      this.isDarkMode = !this.isDarkMode;
      localStorage.setItem("darkMode", this.isDarkMode.toString()); // บันทึกสถานะ dark mode
    }
  }
};
</script>

<style>
.logout-button {
  background: none;
  border: none;
  color: white; /* ปรับสีข้อความให้เข้ากับ navbar */
  cursor: pointer; /* เปลี่ยนเคอร์เซอร์เป็น pointer */
  margin-left: 10px; /* ระยะห่างระหว่างชื่อผู้ใช้และปุ่ม logout */
}

/* เพิ่ม style สำหรับ logout button ในกรณีที่ต้องการ hover หรือ active */
.logout-button:hover {
  text-decoration: underline; /* หากต้องการให้มีเส้นใต้เมื่อ hover */
}

.user-profile-container {
  display: flex; /* ใช้ flexbox เพื่อจัดตำแหน่ง */
  justify-content: flex-end; /* ทำให้เนื้อหาชิดขวา */
  padding: 10px; /* เพิ่มช่องว่างรอบๆ */
  width: 100%; /* ให้ div มีความกว้าง 100% */
}

.user-label {
  color: pink; /* ตั้งค่าสีข้อความเป็นสีชมพู */
  font-weight: bold; /* ทำให้ข้อความเป็นตัวหนา */
}

/* Style สำหรับเมนู */
.nav-button {
  display: inline-block;
  padding: 3px 6px; /* ลดพื้นที่ด้านในระหว่างข้อความและขอบ */
  background-color: white; /* เปลี่ยนสีพื้นหลังเป็นสีขาว */
  color: #3b82f6; /* สีข้อความเป็นสีน้ำเงิน */
  
  border-radius: 5px; /* ทำให้มุมมน */
  text-decoration: none; /* ลบเส้นใต้ */
  font-weight: lighter; /* ตัวหนา */
  transition: background-color 0.3s, color 0.3s; /* เปลี่ยนสีพื้นหลังและสีข้อความเมื่อ hover */
}

/* สไตล์เมื่อ hover หรือ active */
.nav-button:hover {
  background-color: #3b82f6; /* สีน้ำเงินเมื่อ hover */
  color: white; /* ตัวหนังสือเป็นสีขาวเมื่อ hover */
}

.nav-button:active {
  background-color: #2563eb; /* สีเมื่อกดปุ่ม */
  color: white; /* ตัวหนังสือเป็นสีขาวเมื่อกด */
}

/* ทำให้ responsive */
@media (max-width: 600px) {
  .nav-left {
    flex-wrap: wrap; /* ยอมให้เมนูอยู่ในบรรทัดใหม่เมื่อแคบ */
    justify-content: center; /* จัดตำแหน่งให้กลาง */
  }
  
  .nav-button {
    margin: 5px 0; /* เพิ่ม margin ในการย้ายไปที่บรรทัดใหม่ */
    width: 90%; /* ให้วางเต็มพื้นที่ */
    text-align: center; /* จัดข้อความให้กึ่งกลาง */
  }

  .user-profile-container {
    padding: 5px; /* ลด padding เมื่อหน้าจอเล็กลง */
  }

  .user-label {
    font-size: 14px; /* ปรับขนาดตัวอักษรให้เล็กลงเมื่อหน้าจอเล็ก */
  }
}
</style>