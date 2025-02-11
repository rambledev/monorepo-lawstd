<template>
    <div>
      <h2>จัดการ VDO</h2>
      <div>
        <label for="subject">เลือกวิชา:</label>
        <select v-model="selectedSubject" id="subject">
          <option v-for="subject in subjects" :key="subject.sub_code" :value="subject.sub_code">
            {{ subject.sub_name }}
          </option>
        </select>
  
        <br><br>
        <div class="form-group">
          <label for="vdoName">ชื่อ VDO:</label>
          <input style="width:50%" type="text" v-model="vdoName" id="vdoName" placeholder="ชื่อ VDO" />
        </div>
        <br>
        <div class="form-group">
          <label for="vdoLink">ลิงก์ VDO:</label>
          <input style="width:50%" type="text" v-model="vdoLink" id="vdoLink" placeholder="ลิงก์ VDO" />
        </div>
        
        <button class="button" @click="isEditing ? updateVdo() : addVdo()">
          {{ isEditing ? 'บันทึก' : 'เพิ่ม VDO' }}
        </button>
      </div>
  
      <h3>รายการ VDO</h3>
      <table class="table">
    <thead>
      <tr>
        <th>ชื่อวิชา</th> <!-- เพิ่มหัวคอลัมน์ชื่อวิชา -->
        <th>ชื่อ VDO</th>
        <th>ลิงก์ VDO</th>
        <th>Actions</th>
      </tr>
    </thead>
    <tbody>
      <tr v-for="vdo in vdos" :key="vdo.id">
        <td>{{ vdo.sub_name }}</td> <!-- แสดงชื่อวิชา -->
        <td>{{ vdo.vdo_name }}</td>
        <td>{{ vdo.vdo_link }}</td>
        <td>
          <button class="bg-warning text-white font-semibold py-1 px-2 rounded-md shadow-md hover:bg-yellow-700 transition duration-200 ease-in-out focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-opacity-50" @click="editVdo(vdo)">แก้ไข</button>
          <button class="bg-danger text-white font-semibold py-1 px-2 rounded-md shadow-md hover:bg-red-700 transition duration-200 ease-in-out focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-opacity-50" @click="deleteVdo(vdo.id)">ลบ</button>
        </td>
      </tr>
    </tbody>
  </table>
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
        isEditing: false, // สถานะการแก้ไข
        currentVdoId: null, // ID ของ VDO ที่กำลังแก้ไข
      };
    },
    created() {
      this.fetchSubjects();
      this.fetchVdos();
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
      async fetchVdos() {
        try {
          const response = await axios.get(`${import.meta.env.VITE_APP_BASE_URL}/api/vdos`);
          this.vdos = response.data;
        } catch (error) {
          console.error("Error fetching VDOs:", error);
        }
      },
      async addVdo() {
    if (this.selectedSubject && this.vdoName && this.vdoLink) {
      try {
        await axios.post(`${import.meta.env.VITE_APP_BASE_URL}/api/vdos`, {
          sub_code: this.selectedSubject, // ใช้ sub_code
          vdo_name: this.vdoName,
          vdo_link: this.vdoLink,
        });
        this.resetForm(); // ล้างฟอร์มหลังบันทึก
        this.fetchVdos(); // รีเฟรชรายการ VDO
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
        this.currentVdoId = vdo.id; // จำ ID ของ VDO เพื่อใช้ในการอัปเดต
        this.isEditing = true; // ตั้งค่าเป็นโหมดแก้ไข
      },
      async updateVdo() {
        if (this.currentVdoId && this.selectedSubject && this.vdoName && this.vdoLink) {
          try {
            await axios.put(`${import.meta.env.VITE_APP_BASE_URL}/api/vdos/${this.currentVdoId}`, {
              sub_code: this.selectedSubject,
              vdo_name: this.vdoName,
              vdo_link: this.vdoLink,
            });
            this.resetForm(); // ล้างฟอร์มหลังอัปเดต
            this.fetchVdos(); // รีเฟรชรายการ VDO
            this.isEditing = false; // เปลี่ยนกลับไปที่โหมดเพิ่ม
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
            this.fetchVdos(); // รีเฟรชรายการ VDO
          } catch (error) {
            console.error("Error deleting VDO:", error);
          }
        }
      },
      resetForm() {
        this.selectedSubject = '';
        this.vdoName = '';
        this.vdoLink = '';
        this.currentVdoId = null; // ล้าง ID
        this.isEditing = false; // เปลี่ยนกลับสู่โหมดเพิ่ม
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