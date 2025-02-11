<template>
  <div class="dark:bg-gray-800 dark:text-white">
    <h2 class="text-2xl font-bold text-center mb-6">Admin Subject Page</h2>

    <form @submit.prevent="saveSubject" class="max-w-2xl mx-auto">
      <div class="grid grid-cols-2 gap-4 items-center mb-4">
        <label for="sub_code" class="text-right font-semibold dark:text-white">รหัสวิชา:</label>
        <input id="sub_code" v-model="newSubject.sub_code" placeholder="รหัสวิชา" class="border dark:border-gray-600 rounded-lg py-2 px-3 w-full dark:bg-gray-700 dark:text-white" required />

        <label for="sub_name" class="text-right font-semibold dark:text-white">ชื่อวิชา:</label>
        <input id="sub_name" v-model="newSubject.sub_name" placeholder="ชื่อวิชา" class="border dark:border-gray-600 rounded-lg py-2 px-3 w-full dark:bg-gray-700 dark:text-white" required />

        <label for="sub_program" class="text-right font-semibold dark:text-white">สาขาวิชา:</label>
        <input id="sub_program" v-model="newSubject.sub_program" placeholder="สาขาวิชา" class="border dark:border-gray-600 rounded-lg py-2 px-3 w-full dark:bg-gray-700 dark:text-white" required />

        <label for="sub_unit" class="text-right font-semibold dark:text-white">หน่วยกิต:</label>
        <input id="sub_unit" v-model="newSubject.sub_unit" type="number" placeholder="หน่วยกิต" class="border dark:border-gray-600 rounded-lg py-2 px-3 w-full dark:bg-gray-700 dark:text-white" required />

        <label for="sub_term" class="text-right font-semibold dark:text-white">เทอม:</label>
        <input id="sub_term" v-model="newSubject.sub_term" placeholder="เช่น 2/2567" class="border dark:border-gray-600 rounded-lg py-2 px-3 w-full dark:bg-gray-700 dark:text-white" required />

        <label for="sub_teacher" class="text-right font-semibold dark:text-white">อาจารย์ผู้สอน:</label>
        <input id="sub_teacher" v-model="newSubject.sub_teacher" placeholder="อาจารย์ผู้สอน" class="border dark:border-gray-600 rounded-lg py-2 px-3 w-full dark:bg-gray-700 dark:text-white" required />
      </div>

      <div class="flex justify-end">
        <button
          type="submit"
          class="bg-blue-500 text-white font-semibold py-2 px-4 rounded-lg shadow-md hover:bg-blue-600 transition duration-200 ease-in-out focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-opacity-50"
        >
          {{ editMode ? 'บันทึก' : '+ สร้างรายวิชา' }}
        </button>
      </div>
    </form>

    <table class="table-auto border-collapse border border-gray-300 dark:border-gray-600 w-full mt-5">
      <thead>
        <tr>
          <th class="border border-gray-300 px-4 py-2 dark:text-black">รหัสวิชา</th>
          <th class="border border-gray-300 px-4 py-2 dark:text-black">รายวิชา</th>
          <th class="border border-gray-300 px-4 py-2 dark:text-black">สาขาวิชา</th>
          <th class="border border-gray-300 px-4 py-2 dark:text-black">เทอม</th>
          <th class="border border-gray-300 px-4 py-2 dark:text-black">Actions</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="subject in paginatedSubjects" :key="subject.id" class="hover:bg-gray-100 dark:hover:bg-gray-700">
          
          <td class="border border-gray-300 px-4 py-2">{{ subject.sub_code }}<br>{{ subject.sub_teacher }}</td>
          <td class="border border-gray-300 px-4 py-2">{{ subject.sub_name }}<br>{{ subject.sub_unit }} หน่วย</td>
          <td class="border border-gray-300 px-4 py-2">{{ subject.sub_program }}</td>
          <td class="border border-gray-300 px-4 py-2">{{ subject.sub_term }}</td>
          <td class="border border-gray-300 px-4 py-2 text-center">
            <button class="bg-yellow-500 text-white font-semibold py-1 px-2 rounded-md shadow-md hover:bg-yellow-600 transition duration-200 ease-in-out focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-opacity-50" @click="editSubject(subject)">แก้ไข</button>
            <button class="bg-red-500 text-white font-semibold py-1 px-2 rounded-md shadow-md hover:bg-red-600 transition duration-200 ease-in-out focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-opacity-50" @click="deleteSubject(subject.id)">ลบ</button>
          </td>
        </tr>
      </tbody>
    </table>

    <pagination :total="totalPages" :current="currentPage" @pageChange="changePage" />
  </div>
</template>

<script>
import axios from "axios";
import Pagination from '../components/Pagination.vue';

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
        sub_term: "",
        sub_teacher: "",
      },
      currentPage: 1,
      pageSize: 50,
      editMode: false,
      subjectToEdit: null,  // ใช้สำหรับเก็บ ID ของ subject ที่จะถูกแก้ไข
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
        console.log("Fetched subjects:", this.subjects); 
      } catch (error) {
        console.error("Error fetching subjects:", error);
      }
    },
    async addSubject() {
  try {
    await axios.post(`${import.meta.env.VITE_APP_BASE_URL}/api/subjects`, this.newSubject);
    await this.fetchSubjects(); // โหลดข้อมูลใหม่
    this.resetForm();
  } catch (error) {
    console.error("Error adding subject:", error);
  }
}
,
    async editSubject(subject) {
      this.newSubject = { ...subject }; // ทำสำเนาข้อมูลของ subject เพื่อแก้ไข
      this.editMode = true;
      this.subjectToEdit = subject.id; // เก็บ ID ของ subject ที่จะแก้ไข
      console.log(this.newSubject);
    },
    async saveSubject() {
  if (this.editMode && this.subjectToEdit) {
    console.log(this.newSubject); // ตรวจสอบข้อมูลก่อนส่ง
    try {
      await axios.put(`${import.meta.env.VITE_APP_BASE_URL}/api/subjects/${this.subjectToEdit}`, this.newSubject, {
        headers: { 'Content-Type': 'application/json' }
      });
      await this.fetchSubjects(); // โหลดข้อมูลใหม่
      this.resetForm();
    } catch (error) {
      console.error("Error saving subject:", error.response?.data || error.message);
    }
  } else {
    await this.addSubject();
  }
}


,
async deleteSubject(id) {
  const confirmed = window.confirm("คุณแน่ใจว่าจะลบรายวิชานี้ใช่ไหม?");
  if (confirmed) {
    try {
      await axios.delete(`${import.meta.env.VITE_APP_BASE_URL}/api/subjects/${id}`);
      await this.fetchSubjects(); // โหลดข้อมูลใหม่
    } catch (error) {
      console.error("Error deleting subject:", error);
    }
  }
}
,
    changePage(pageNumber) {
      this.currentPage = pageNumber;
    },
    resetForm() {
      this.newSubject = { sub_code: "", sub_name: "", sub_program: "", sub_unit: null, sub_term: "", sub_teacher: "" };
      this.editMode = false;
      this.subjectToEdit = null;
    },
  },
  mounted() {
    this.fetchSubjects();
  },
};
</script>

<style>
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

@media (max-width: 600px) {
  th, td {
    font-size: 12px;
    padding: 5px;
  }
}
</style>