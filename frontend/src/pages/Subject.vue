<template>
  <div>
    <h1 class="text-3xl font-bold mb-4">รายวิชาทั้งหมด</h1>
    <div class="table-container">
      <table class="table-auto border-collapse border border-gray-300 w-full">
        <tbody>
          <tr v-for="subject in paginatedSubjects" :key="subject.id" class="hover:bg-gray-100">
            <td class="border border-gray-300 px-4 py-2">
              <label class="font-bold">{{ subject.sub_name }}</label>
              <br>ผู้สอน : {{ subject.sub_teacher }}
              <br>
              เทอม : {{ subject.sub_term }}
              <br> {{ subject.sub_unit }} หน่วย
              <br>
              <button @click="viewSubjectDetail(subject.sub_code)" class="bg-primary text-white font-semibold py-1 px-2 rounded-md shadow-md hover:bg-red-700 transition duration-200 ease-in-out focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-opacity-50">
                เลือก
              </button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    <pagination :total="totalPages" :current="currentPage" @pageChange="changePage" />
  </div>
</template>

<script>
import Pagination from '../components/Pagination.vue';

export default {
  name: "Subject",
  components: {
    Pagination,
  },
  data() {
    return {
      subjects: [],
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
  const apiUrl = `${import.meta.env.VITE_APP_BASE_URL}/api/subjects`;
  console.log("Fetching subjects from API:", apiUrl);

  try {
    const response = await fetch(apiUrl, {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
      },
      credentials: 'include',  // ส่งคุกกี้ข้ามโดเมน
    });

    if (response.ok) {
      const data = await response.json();
      console.log("Subjects data:", data);
      this.subjects = data.data; // เข้าถึงอาเรย์ data
    } else {
      console.error('Error fetching subjects:', response.statusText);
    }
  } catch (error) {
    console.error("Error fetching subjects:", error);
  }
},
    viewSubjectDetail(subCode) {
      this.$router.push({ name: 'SubjectDetail', params: { sub_code: subCode } });
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
.table-container {
  overflow-x: auto; /* ให้ตารางเลื่อนเมื่อหน้าจอเล็ก */
}

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
    font-size: 12px; /* ลดขนาดตัวอักษรลง */
    padding: 5px; /* ลด padding */
  }
}
</style>
