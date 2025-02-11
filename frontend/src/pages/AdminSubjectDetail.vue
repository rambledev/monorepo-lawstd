<template>
  <div class="bg-white dark:bg-gray-900 text-gray-900 dark:text-white">
    <h2 class="text-2xl font-bold mb-4">รายละเอียดวิชา</h2>

    <!-- ฟอร์มสำหรับอัปเดตหรือสร้างวิชาใหม่ -->
    <form @submit.prevent="saveOrUpdateSubject" class="max-w-2xl mx-auto mt-8">
      <div class="grid grid-cols-2 gap-4 items-center mb-4">
        <label for="sub_code" class="text-right font-semibold dark:text-white">รหัสวิชา:</label>
        <input 
          id="sub_code" 
          v-model="newSubject.sub_code" 
          placeholder="รหัสวิชา" 
          class="border dark:border-gray-600 rounded-lg py-2 px-3 w-full dark:bg-gray-700 dark:text-white" 
          required 
          :disabled="isEditing"
        />

        <label for="sub_name" class="text-right font-semibold dark:text-white">ชื่อวิชา:</label>
        <input 
          id="sub_name" 
          v-model="newSubject.sub_name" 
          placeholder="ชื่อวิชา" 
          class="border dark:border-gray-600 rounded-lg py-2 px-3 w-full dark:bg-gray-700 dark:text-white" 
          required 
        />

        <label for="sub_program" class="text-right font-semibold dark:text-white">สาขาวิชา:</label>
        <input 
          id="sub_program" 
          v-model="newSubject.sub_program" 
          placeholder="สาขาวิชา" 
          class="border dark:border-gray-600 rounded-lg py-2 px-3 w-full dark:bg-gray-700 dark:text-white" 
          required 
        />

        <label for="sub_unit" class="text-right font-semibold dark:text-white">หน่วยกิต:</label>
        <input 
          id="sub_unit" 
          v-model="newSubject.sub_unit" 
          type="number" 
          placeholder="หน่วยกิต" 
          class="border dark:border-gray-600 rounded-lg py-2 px-3 w-full dark:bg-gray-700 dark:text-white" 
          required 
        />

        <label for="sub_term" class="text-right font-semibold dark:text-white">เทอม:</label>
        <input 
          id="sub_term" 
          v-model="newSubject.sub_term" 
          placeholder="เช่น 2/2567" 
          class="border dark:border-gray-600 rounded-lg py-2 px-3 w-full dark:bg-gray-700 dark:text-white" 
          required 
        />

        <label for="sub_teacher" class="text-right font-semibold dark:text-white">อาจารย์ผู้สอน:</label>
        <input 
          id="sub_teacher" 
          v-model="newSubject.sub_teacher" 
          placeholder="อาจารย์ผู้สอน" 
          class="border dark:border-gray-600 rounded-lg py-2 px-3 w-full dark:bg-gray-700 dark:text-white" 
          required 
        />
      </div>

      <div class="flex justify-end">
        <button
          type="submit"
          class="bg-blue-500 text-white font-semibold py-2 px-4 rounded-lg shadow-md hover:bg-blue-600 transition duration-200 ease-in-out focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-opacity-50"
        >
          {{ isEditing ? 'อัปเดตรายวิชา' : '+ สร้างรายวิชา' }}
        </button>
      </div>
    </form>

    <!-- ส่วนแสดง VDO -->
    <div class="mt-8">
      <h3 class="text-xl font-bold mb-4">VDO</h3>
      <ul>
        <li v-for="vdo in vdos" :key="vdo.vdo_id" class="mb-2">
          <a :href="vdo.vdo_link" target="_blank" class="text-blue-500 hover:underline">
            {{ vdo.vdo_name }}
          </a>
        </li>
      </ul>
    </div>

    <!-- ส่วนแสดงเอกสาร -->
    <div class="mt-8">
      <h3 class="text-xl font-bold mb-4">เอกสาร</h3>
      <ul>
        <li v-for="doc in docs" :key="doc.id" class="mb-2">
          <a :href="doc.doc_link" target="_blank" class="text-blue-500 hover:underline">
            {{ doc.doc_name }}
          </a>
        </li>
      </ul>
    </div>
  </div>
</template>

<script>
export default {
  name: "AdminSubjectDetail",
  data() {
    return {
      isEditing: false,
      subjectCode: '',
      newSubject: {
        sub_code: '',
        sub_name: '',
        sub_program: '',
        sub_unit: '',
        sub_term: '',
        sub_teacher: ''
      },
      vdos: [], // ข้อมูล VDO
      docs: []  // ข้อมูลเอกสาร
    };
  },
  created() {
    this.fetchSubjectDetail();  // เรียกใช้ฟังก์ชันดึงข้อมูลเมื่อโหลดหน้า
  },
  methods: {
    // ฟังก์ชันดึงข้อมูลวิชาตามรหัสวิชาจาก URL
    async fetchSubjectDetail() {
      this.subjectCode = this.$route.params.sub_code;  // ดึงรหัสวิชาจาก URL
      if (this.subjectCode) {
        try {
          // ดึงข้อมูล subject
          const subjectResponse = await fetch(`${import.meta.env.VITE_APP_BASE_URL}/api/subjects/${this.subjectCode}`);
          if (!subjectResponse.ok) throw new Error('Failed to fetch subject details');
          const subject = await subjectResponse.json();
          this.isEditing = true;
          this.newSubject = {
            sub_code: subject.sub_code,
            sub_name: subject.sub_name,
            sub_program: subject.sub_program,
            sub_unit: subject.sub_unit,
            sub_term: subject.sub_term,
            sub_teacher: subject.sub_teacher
          };

          // ดึงข้อมูล VDO
          const vdoResponse = await fetch(`${import.meta.env.VITE_APP_BASE_URL}/api/vdos/${this.subjectCode}`);
          if (!vdoResponse.ok) throw new Error('Failed to fetch VDOs');
          this.vdos = await vdoResponse.json();

          // ดึงข้อมูลเอกสาร
          const docResponse = await fetch(`${import.meta.env.VITE_APP_BASE_URL}/api/doc-subject/${this.subjectCode}`);
          if (!docResponse.ok) throw new Error('Failed to fetch documents');
          this.docs = await docResponse.json();
        } catch (error) {
          console.error("Error fetching data:", error);
        }
      }
    },

    // ฟังก์ชันบันทึกหรืออัปเดตข้อมูล
    async saveOrUpdateSubject() {
      if (this.newSubject.sub_code && this.newSubject.sub_name) {
        const method = this.isEditing ? 'PUT' : 'POST';
        const url = this.isEditing
          ? `${import.meta.env.VITE_APP_BASE_URL}/api/subjects/${this.newSubject.sub_code}`
          : `${import.meta.env.VITE_APP_BASE_URL}/api/subjects`;
        
        try {
          const response = await fetch(url, {
            method: method,
            headers: {
              'Content-Type': 'application/json'
            },
            body: JSON.stringify(this.newSubject)
          });
          if (!response.ok) throw new Error('Failed to save or update subject');
          alert(this.isEditing ? "อัปเดตวิชาเรียบร้อยแล้ว" : "บันทึกวิชาเรียบร้อยแล้ว");
          if (!this.isEditing) {
            this.newSubject = {
              sub_code: '',
              sub_name: '',
              sub_program: '',
              sub_unit: '',
              sub_term: '',
              sub_teacher: ''
            };
          }
        } catch (error) {
          console.error("Error saving or updating subject:", error);
        }
      } else {
        alert("กรุณากรอกข้อมูลให้ครบถ้วน!");
      }
    }
  }
};
</script>