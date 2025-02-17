<template>
  <div id="app" class="flex-col items-center justify-center min-h-screen">
    <header class="mb-1">
      <h1 class="text-4xl font-bold text-center">LAWSTD RMU</h1>
    </header>

    <div v-if="userProfile && userProfile.USERFULLNAME" class="user-profile-container">
    <label class="font-bold user-label">
        ผู้ใช้งาน : {{ userProfile.USERFULLNAME }}
    </label>
</div>

    <nav class="nav-container mb-4">
      <div class="nav-left">
        <router-link class="mx-4 nav-link" to="/home">Home</router-link>
        <router-link class="mx-4 nav-link" to="/subject">Learning</router-link>
      </div>
      <div class="nav-right">
       
          <button @click="logout" class="logout-button">
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
  name: "UserLayout",
  data() {
    return {
      userProfile: null,
    };
  },
  mounted() {
    const storedProfile = localStorage.getItem("userProfile");
    console.log("userProfile = ", storedProfile);
    if (storedProfile && storedProfile !== "undefined") {
      try {
        this.userProfile = JSON.parse(storedProfile);
      } catch (error) {
        console.error("Error parsing userProfile:", error);
      }
    }
},
  methods: {
    logout() {
      localStorage.removeItem("userProfile");
      localStorage.removeItem("isAuthenticated"); // ล้าง status ของการล็อกอิน
      this.isAuthen = false; // อัปเดต trạng tháiใน component

      this.$router.push("/login"); // เปลี่ยนเส้นทางไปที่หน้า Login
    },
  },
};
</script>

<style>
/* Style สำหรับ logout button */
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

/* ทำให้ responsive */
@media (max-width: 600px) {
  .user-profile-container {
    padding: 5px; /* ลด padding เมื่อหน้าจอเล็กลง */
  }

  .user-label {
    font-size: 14px; /* ปรับขนาดตัวอักษรให้เล็กลงเมื่อหน้าจอเล็ก */
  }
}


</style>
