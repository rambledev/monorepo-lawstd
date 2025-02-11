<template>
  <div>
    <h2>รายชื่อนักศึกษาในวิชา: {{ subjectCode }}</h2>

    <button class="bg-yellow-500 text-white hover:bg-yellow-600 p-2 rounded" @click="openSearchDialog">ค้นหารายชื่อนักเรียน</button>

    <!-- Dialog สำหรับค้นหารายนักศึกษา -->
    <div v-if="isDialogOpen" class="dialog">
      <h3>ค้นหานักเรียน</h3>
      <input 
        type="text" 
        v-model="searchKeyword" 
        placeholder="ค้นหารหัส/ชื่อนักเรียน..." 
        @input="searchStudents"  
      />
      <button class="bg-red-500 text-white hover:bg-red-600 px-4 py-2 rounded" @click="closeSearchDialog">x</button>
      <!-- ผลการค้นหานักศึกษา -->
      <ul v-if="searchResults.length > 0" class="dropdown">
        <li 
          v-for="student in searchResults" 
          :key="student.std_code"
          @click="confirmAddStudent(student)" 
          :class="['dropdown-item', { selected: selectedSearchResults.includes(student.std_code) }]"
        >
          {{ student.std_code }} - {{ student.std_name }}
        </li>
      </ul>
    </div>

    <table class="table-auto border-collapse border border-gray-300 w-full">
      <thead>
        <tr>
          <th>ชื่อ</th>
          <th>รหัสนักศึกษา</th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="student in students" :key="student.std_code">
          <td>{{ student.std_name }}</td>
          <td>{{ student.std_code }}</td>
          <td>
              <button class="bg-red-500 text-white hover:bg-red-600 px-4 py-2 rounded" @click="removeStudent(student.std_code)">ลบ</button>
          </td>
        </tr>
      </tbody>
    </table>

  </div>
</template>

<script>
import Swal from 'sweetalert2';

export default {
  name: "AdminStdList",
  data() {
    return {
      subjectCode: this.$route.params.subCode,
      students: [],
      selectedStudents: [],
      isDialogOpen: false,
      searchKeyword: '',
      searchResults: [],
      selectedSearchResults: [],
    };
  },
  methods: {
    async fetchStudents() {
      try {
        const response = await fetch(`${import.meta.env.VITE_APP_BASE_URL}/api/students?sub_code=${this.subjectCode}`);
        if (!response.ok) throw new Error("Failed to fetch students");
        this.students = await response.json();
      } catch (error) {
        console.error("Error fetching students:", error);
      }
    },
    openSearchDialog() {
      this.isDialogOpen = true;
      this.searchKeyword = '';
      this.searchResults = [];
      this.selectedSearchResults = [];
    },
    closeSearchDialog() {
      this.isDialogOpen = false;
    },
    async searchStudents() {
      if (this.searchKeyword.length === 0) {
        this.searchResults = [];
        return;
      }
      try {
        const response = await fetch(`${import.meta.env.VITE_APP_BASE_URL}/api/students/search?keyword=${this.searchKeyword}`);
        if (!response.ok) throw new Error("Failed to search students");
        this.searchResults = await response.json();
      } catch (error) {
        console.error("Error searching students:", error);
      }
    },
    confirmAddStudent(student) {
      Swal.fire({
        title: 'ยืนยันการเพิ่มนักเรียน',
        text: `เพิ่ม ${student.std_name} เข้ารายวิชานี้หรือไม่?`,
        icon: 'warning',
        showCancelButton: true,
        confirmButtonText: 'ยืนยัน',
        cancelButtonText: 'ยกเลิก'
      }).then(async (result) => {
        if (result.isConfirmed) {
          await this.addStudentToSubject(student);
        }
      });
    },
    async addStudentToSubject(student) {
      try {
        const response = await fetch(`${import.meta.env.VITE_APP_BASE_URL}/api/subject-list`, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify({
            sub_code: this.subjectCode,
            std_code: student.std_code,
            status: 'active',
          }),
        });
        if (!response.ok) throw new Error("Failed to add student to subject list");
        Swal.fire('สำเร็จ!', `${student.std_name} ได้ถูกเพิ่มในรายวิชา ${this.subjectCode}`, 'success');
        this.fetchStudents();
      } catch (error) {
        console.error("Error adding student to subject list:", error);
        Swal.fire('เกิดข้อผิดพลาด!', 'ไม่สามารถเพิ่มนักเรียนได้', 'error');
      }
    },
    async removeStudent(studentId) {
      const confirmed = window.confirm("คุณแน่ใจว่าต้องการลบรายชื่อนักศึกษานี้ใช่ไหม?");
      if (confirmed) {
        try {
          const response = await fetch(`${import.meta.env.VITE_APP_BASE_URL}/api/students-list/${studentId}`, {
            method: 'DELETE',
          });
          if (!response.ok) throw new Error("Failed to delete student");
          this.fetchStudents();
        } catch (error) {
          console.error("Error deleting student:", error);
        }
      }
    },
  },
  mounted() {
    this.fetchStudents();
  },
};
</script>

<style scoped>
.dropdown {
  border: 1px solid #ccc;
  max-height: 200px;
  overflow-y: auto;
  position: absolute;
  background: white;
  width: 100%;
  left: 0;
  z-index: 10;
}

.dropdown-item {
  padding: 10px;
  cursor: pointer;
}

.dropdown-item.selected {
  background-color: #d0eaff;
}

.dropdown-item:hover {
  background: #f0f0f0;
}

.dialog {
  position: fixed;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  border: 1px solid #ccc;
  padding: 20px;
  background: white;
  z-index: 100;
  width: 80%;
}
</style>
