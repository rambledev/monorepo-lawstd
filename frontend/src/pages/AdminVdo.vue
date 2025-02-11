<template>
  <div class="bg-white dark:bg-gray-900 text-gray-900 dark:text-white">
    <h2 class="text-2xl font-bold mb-4">จัดการ VDO</h2>
    <div>
      <label for="subject" class="font-semibold">เลือกวิชา:</label>
      <select v-model="selectedSubject" id="subject" class="border border-gray-300 rounded-md p-2 dark:bg-gray-800 dark:border-gray-600 dark:text-white">
        <option value="" disabled>-- เลือกวิชา --</option>
        <option v-for="subject in subjects" :key="subject.sub_code" :value="subject.sub_code">
          {{ subject.sub_name }}
        </option>
      </select>

      <br><br>
      <div class="form-group">
        <label for="vdoName" class="font-semibold">ชื่อ VDO:</label>
        <input 
          style="width:50%" 
          type="text" 
          v-model="vdoName" 
          id="vdoName" 
          placeholder="ชื่อ VDO" 
          class="border border-gray-300 rounded-md p-2 dark:bg-gray-800 dark:border-gray-600 dark:text-white"
        />
      </div>
      <br>
      <div class="form-group">
        <label for="vdoLink" class="font-semibold">ลิงก์ VDO:</label>
        <input 
          style="width:50%" 
          type="text" 
          v-model="vdoLink" 
          id="vdoLink" 
          placeholder="ลิงก์ VDO" 
          class="border border-gray-300 rounded-md p-2 dark:bg-gray-800 dark:border-gray-600 dark:text-white"
        />
      </div>
      
      <button 
        class="bg-blue-500 text-white font-semibold py-2 px-4 rounded-md shadow-md hover:bg-blue-600 transition duration-200 ease-in-out focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-opacity-50 dark:bg-blue-700 dark:hover:bg-blue-600 dark:focus:ring-blue-400"
        @click="isEditing ? updateVdo() : addVdo()"
      >
        {{ isEditing ? 'บันทึก' : 'เพิ่ม VDO' }}
      </button>
    </div>

    <h3 class="text-xl font-semibold mt-6">รายการ VDO</h3>
    <table class="table-auto w-full mt-4 border-collapse border border-gray-300 dark:border-gray-700" v-if="vdos.length > 0">
      <thead>
        <tr class="bg-gray-100 dark:bg-gray-800">
          <th class="border px-4 py-2 dark:text-white">ชื่อวิชา</th>
          <th class="border px-4 py-2 dark:text-white">ชื่อ VDO</th>
          <th class="border px-4 py-2 dark:text-white">ลิงก์ VDO</th>
          <th class="border px-4 py-2 dark:text-white">Actions</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="vdo in vdos" :key="vdo.id" class="hover:bg-gray-50 dark:hover:bg-gray-700">
          <td class="border px-4 py-2">{{ vdo.sub_name }}</td>
          <td class="border px-4 py-2">{{ vdo.vdo_name }}</td>
          <td class="border px-4 py-2">{{ vdo.vdo_link }}</td>
          <td class="border px-4 py-2 text-center">
            <button 
              class="bg-yellow-500 text-white font-semibold py-1 px-2 rounded-md shadow-md hover:bg-yellow-600 transition duration-200 ease-in-out focus:outline-none focus:ring-2 focus:ring-yellow-500 focus:ring-opacity-50 dark:bg-yellow-600 dark:hover:bg-yellow-500"
              @click="editVdo(vdo)"
            >
              แก้ไข
            </button>
            <button 
              class="bg-red-500 text-white font-semibold py-1 px-2 rounded-md shadow-md hover:bg-red-600 transition duration-200 ease-in-out focus:outline-none focus:ring-2 focus:ring-red-500 focus:ring-opacity-50 dark:bg-red-600 dark:hover:bg-red-500"
              @click="deleteVdo(vdo.id)"
            >
              ลบ
            </button>
          </td>
        </tr>
      </tbody>
    </table>
    <p v-else>ไม่มี VDO สำหรับวิชานี้</p>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  name: "AdminVdo",
  data() {
    return {
      subjects: [],
      vdos: [],
      selectedSubject: '',
      vdoName: '',
      vdoLink: '',
      isEditing: false,
      currentVdoId: null,
    };
  },
  watch: {
    selectedSubject(newSubject) {
      this.fetchVdosBySubject(newSubject);
    }
  },
  created() {
    this.fetchSubjects(); 
  },
  methods: {
    async fetchSubjects() {
      try {
        const response = await axios.get(`${import.meta.env.VITE_APP_BASE_URL}/api/subjects`);
        this.subjects = response.data;
      } catch (error) {
        console.error("Error fetching subjects:", error);
      }
    },
    async fetchVdosBySubject(subjectCode) {
    if (!subjectCode) {
      this.vdos = []; // Clear vdos if no subject is selected
      return;
    }

    try {
      const response = await axios.get(`${import.meta.env.VITE_APP_BASE_URL}/api/vdos-subject/${subjectCode}`);
      this.vdos = response.data;
    } catch (error) {
      console.error("Error fetching VDOs:", error);
    }
  },
    async addVdo() {
      if (this.selectedSubject && this.vdoName && this.vdoLink) {
        try {
          await axios.post(`${import.meta.env.VITE_APP_BASE_URL}/api/vdos`, {
            sub_code: this.selectedSubject,
            vdo_name: this.vdoName,
            vdo_link: this.vdoLink,
          });
          this.resetForm();
          this.fetchVdosBySubject(this.selectedSubject);
        } catch (error) {
          console.error("Error adding VDO:", error.response.data);
        }
      } else {
        alert("กรุณากรอกข้อมูลให้ครบถ้วน!");
      }
    },
    editVdo(vdo) {
      this.selectedSubject = vdo.sub_code;
      this.vdoName = vdo.vdo_name;
      this.vdoLink = vdo.vdo_link;
      this.currentVdoId = vdo.id;
      this.isEditing = true;
    },
    async updateVdo() {
      if (this.currentVdoId && this.selectedSubject && this.vdoName && this.vdoLink) {
        try {
          await axios.put(`${import.meta.env.VITE_APP_BASE_URL}/api/vdos/${this.currentVdoId}`, {
            sub_code: this.selectedSubject,
            vdo_name: this.vdoName,
            vdo_link: this.vdoLink,
          });
          this.resetForm();
          this.fetchVdosBySubject(this.selectedSubject);
          this.isEditing = false;
        } catch (error) {
          console.error("Error updating VDO:", error);
        }
      } else {
        alert("กรุณากรอกข้อมูลให้ครบถ้วน!");
      }
    },
    async deleteVdo(vdoId) {
      if (confirm("คุณแน่ใจหรือไม่ว่าต้องการลบ VDO นี้?")) {
        try {
          await axios.delete(`${import.meta.env.VITE_APP_BASE_URL}/api/vdos/${vdoId}`);
          this.fetchVdosBySubject(this.selectedSubject);
        } catch (error) {
          console.error("Error deleting VDO:", error);
        }
      }
    },
    resetForm() {
      this.selectedSubject = '';
      this.vdoName = '';
      this.vdoLink = '';
      this.currentVdoId = null;
      this.isEditing = false;
    },
  },
};
</script>

<style scoped>
.button {
  background-color: #007bff; /* สี primary */
  color: white;
  border: none;
  border-radius: 5px;
  padding: 10px 20px;
  cursor: pointer;
  transition: background-color 0.3s, transform 0.2s;
}

.button:hover {
  background-color: #0056b3; /* สีเมื่อชี้เมาส์ */
  transform: translateY(-2px); /* เคลื่อนไหวเล็กน้อยเมื่อชี้เมาส์ */
}

.table {
  width: 100%;
  border-collapse: collapse; /* รวมขอบ */
}

.table th, .table td {
  border: 1px solid #ccc; /* ขอบ */
  padding: 8px; /* ช่องว่างภายในช่อง */
  text-align: left; /* จัดแนวซ้าย */
}

.table th {
  background-color: #f2f2f2; /* สีพื้นหลังหัวข้อ */
}

h2 {
  margin-bottom: 20px;
}

h3 {
  margin-top: 20px;
}
</style>