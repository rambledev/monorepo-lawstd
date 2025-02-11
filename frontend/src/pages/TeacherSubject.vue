<template>
    <div>
      <h2>Teacher Subject Page</h2>
  
      <!-- <form @submit.prevent="addSubject">
        <input v-model="newSubject.sub_code" placeholder="รหัสวิชา" required />
        <input v-model="newSubject.sub_name" placeholder="ชื่อวิชา" required />
        <input v-model="newSubject.sub_program" placeholder="สาขาวิชา" required />
        <input v-model="newSubject.sub_unit" type="number" placeholder="หน่วยกิต" required />
        <button type="submit" class="bg-success text-white font-semibold py-2 px-4 rounded-lg shadow-md hover:bg-blue-700 transition duration-200 ease-in-out focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-opacity-50"
        >+ สร้างรายวิชา</button>
      </form> -->
  
      <form @submit.prevent="addSubject" class="max-w-2xl mx-auto">
    <div class="grid grid-cols-2 gap-4 items-center mb-4">
      <label for="sub_code" class="text-right font-semibold">รหัสวิชา:</label>
      <input id="sub_code" v-model="newSubject.sub_code" placeholder="รหัสวิชา" class="border rounded-lg py-2 px-3 w-full" required />
  
      <label for="sub_name" class="text-right font-semibold">ชื่อวิชา:</label>
      <input id="sub_name" v-model="newSubject.sub_name" placeholder="ชื่อวิชา" class="border rounded-lg py-2 px-3 w-full" required />
  
      <label for="sub_program" class="text-right font-semibold">สาขาวิชา:</label>
      <input id="sub_program" v-model="newSubject.sub_program" placeholder="สาขาวิชา" class="border rounded-lg py-2 px-3 w-full" required />
  
      <label for="sub_unit" class="text-right font-semibold">หน่วยกิต:</label>
      <input id="sub_unit" v-model="newSubject.sub_unit" type="number" placeholder="หน่วยกิต" class="border rounded-lg py-2 px-3 w-full" required />
    </div>
  
    <div class="flex justify-end">
      <button
        type="submit"
        class="bg-success text-white font-semibold py-2 px-4 rounded-lg shadow-md hover:bg-success-700 transition duration-200 ease-in-out focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-opacity-50"
      >
        + สร้างรายวิชา
      </button>
    </div>
  </form>
  
  
  <table class="table-auto border-collapse border border-gray-300 w-full">
    <thead >
      <tr >
        <th class="border border-gray-300 px-4 py-2">Id</th>
        <th class="border border-gray-300 px-4 py-2">รหัสวิชา</th>
        <th class="border border-gray-300 px-4 py-2">รายวิชา</th>
        <th class="border border-gray-300 px-4 py-2">สาขาวิชา</th>
        <th class="border border-gray-300 px-4 py-2">จำนวนหน่วยกิต</th>
        <th class="border border-gray-300 px-4 py-2">Actions</th>
      </tr>
    </thead>
    <tbody>
      <tr v-for="subject in paginatedSubjects" :key="subject.id" class="hover:bg-gray-100">
        <td class="border border-gray-300 px-4 py-2">{{ subject.id }}</td>
        <td class="border border-gray-300 px-4 py-2">{{ subject.sub_code }}</td>
        <td class="border border-gray-300 px-4 py-2">{{ subject.sub_name }}</td>
        <td class="border border-gray-300 px-4 py-2">{{ subject.sub_program }}</td>
        <td class="border border-gray-300 px-4 py-2">{{ subject.sub_unit }}</td>
        <td class="border border-gray-300 px-4 py-2 text-center">
          <button class="bg-warning text-white font-semibold py-1 px-2 rounded-md shadow-md hover:bg-yellow-700 transition duration-200 ease-in-out focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-opacity-50" @click="editSubject(subject)">Edit</button>
          <button class="bg-danger text-white font-semibold py-1 px-2 rounded-md shadow-md hover:bg-red-700 transition duration-200 ease-in-out focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-opacity-50" @click="deleteSubject(subject.id)">Delete</button>
        </td>
      </tr>
    </tbody>
  </table>
  
  
  
      <pagination :total="totalPages" :current="currentPage" @pageChange="changePage" />
    </div>
  </template>
  
  <script>
  import axios from "axios";
  import Pagination from '../components/Pagination.vue'; // เปลี่ยนจาก "@components" เป็น "../components"
  export default {
    name: "AdminSubject",
    components: {
      Pagination,
    },
    data() {
      return {
        subjects: [],
        newSubject: {
          sub_code: "",
          sub_name: "",
          sub_program: "",
          sub_unit: null,
        },
        currentPage: 1,
        pageSize: 50,
      };
    },
    computed: {
      paginatedSubjects() {
        const start = (this.currentPage - 1) * this.pageSize;
        return this.subjects.slice(start, start + this.pageSize);
      },
      totalPages() {
        return Math.ceil(this.subjects.length / this.pageSize);
      },
    },
    methods: {
      async fetchSubjects() {
        try {
          const response = await axios.get(`${import.meta.env.VITE_APP_BASE_URL}/api/subjects`);
          this.subjects = response.data;
          console.log("axios subject =>"+this.subjects); // ตรวจสอบค่าที่ดึงมาจาก API
        } catch (error) {
          console.error("Error fetching subjects:", error);
        }
      },
      async addSubject() {
        try {
          await axios.post(`${import.meta.env.VITE_APP_BASE_URL}/api/subjects`, this.newSubject);
          this.fetchSubjects(); // Refresh list after adding
          this.newSubject = { sub_code: "", sub_name: "", sub_program: "", sub_unit: null }; // Reset form
        } catch (error) {
          console.error("Error adding subject:", error);
        }
      },
      async editSubject(subject) {
        // Implement edit logic here. This could include showing a modal or similar
      },
      async deleteSubject(id) {
        // แสดง confirm dialog ก่อนลบ
    const confirmed = window.confirm("คุณแน่ใจว่าจะลบรายวิชานี้ใช่ไหม?");
    if (confirmed) {
      try {
        await axios.delete(`${import.meta.env.VITE_APP_BASE_URL}/api/subjects/${id}`);
        this.fetchSubjects(); // Refresh list after deleting
      } catch (error) {
        console.error("Error deleting subject:", error);
      }
    }
      },
      changePage(pageNumber) {
        this.currentPage = pageNumber;
      },
    },
    mounted() {
      this.fetchSubjects();
    },
  };
  </script>
  
  <style>
  /* Styles for your table and other elements */
  table {
    width: 100%;
    border-collapse: collapse;
  }
  
  td, th {
    border: 1px solid #ddd;
    padding: 8px;
  }
  
  th {
    background-color: #f2f2f2;
  }
  </style>