<template>
    <div id="app" class=" flex-col items-center justify-center min-h-screen">
  <header class="mb-4">
    <h1 class="text-4xl font-bold">Teacher</h1>
  </header>
  
  <nav class="nav-container mb-4">
    <router-link class="mx-4 nav-link" to="/teacher/dashboard">Dashboard</router-link>
    <router-link class="mx-4 nav-link" to="/teacher/subject">จัดการรายวิชา</router-link>
    <router-link class="mx-4 nav-link" to="/teacher/vdo">จัดการVDO</router-link>
    <router-link class="mx-4 nav-link" to="/teacher/permission">กำหนดสิทธิ์รายวิชา</router-link>
</nav>
  
  <div class="card">
    <router-view />
  </div>
</div>
  </template>
  
  <script>
  export default {
    name: "AdminLayout",
  };
  </script>


<style>

  .nav-container {
    background-color: #f905f9; /* กำหนดเป็นสีทึบ เช่น สีเทาเข้ม */
    padding: 10px; /* เพิ่ม Padding เพื่อความสวยงาม */
    border-radius: 10px;
  }
  
  .nav-link {
    color: white; /* กำหนดตัวหนังสือให้เป็นสีขาว */
  }
</style>