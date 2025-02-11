<template>
  <div class="bg-white dark:bg-gray-900 text-gray-900 dark:text-white">
    <h2 class="text-2xl font-bold mb-4">จัดการ เอกสารที่เกี่ยวข้อง</h2>
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
        <label for="fileName" class="font-semibold">ชื่อเอกสาร:</label>
        <input 
          style="width:50%" 
          type="text" 
          v-model="fileName" 
          id="fileName" 
          placeholder="ชื่อเอกสาร" 
          class="border border-gray-300 rounded-md p-2 dark:bg-gray-800 dark:border-gray-600 dark:text-white"
        />
      </div>
      <br>
      <div class="form-group">
        <label for="fileLink" class="font-semibold">ลิงก์เอกสาร:</label>
        <input 
          style="width:50%" 
          type="text" 
          v-model="fileLink" 
          id="fileLink" 
          placeholder="ลิงก์เอกสาร" 
          class="border border-gray-300 rounded-md p-2 dark:bg-gray-800 dark:border-gray-600 dark:text-white"
        />
      </div>
      
      <button 
        class="bg-blue-500 text-white font-semibold py-2 px-4 rounded-md shadow-md hover:bg-blue-600 transition duration-200 ease-in-out focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-opacity-50 dark:bg-blue-700 dark:hover:bg-blue-600 dark:focus:ring-blue-400"
        @click="isEditing ? updateDoc() : addDoc()"
      >
        {{ isEditing ? 'บันทึก' : 'เพิ่มเอกสาร' }}
      </button>
    </div>

    <h3 class="text-xl font-semibold mt-6">รายการเอกสาร</h3>
    <table class="table-auto w-full mt-4 border-collapse border border-gray-300 dark:border-gray-700" v-if="docs.length > 0">
      <thead>
        <tr class="bg-gray-100 dark:bg-gray-800">
          <th class="border px-4 py-2 dark:text-white">ชื่อวิชา</th>
          <th class="border px-4 py-2 dark:text-white">ชื่อเอกสาร</th>
          <th class="border px-4 py-2 dark:text-white">ลิงก์เอกสาร</th>
          <th class="border px-4 py-2 dark:text-white">Actions</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="doc in docs" :key="doc.id" class="hover:bg-gray-50 dark:hover:bg-gray-700">
          <td class="border px-4 py-2">{{ doc.sub_name }}</td>
          <td class="border px-4 py-2">{{ doc.file_name }}</td>
          <td class="border px-4 py-2">{{ doc.file_link }}</td>
          <td class="border px-4 py-2 text-center">
            <button 
              class="bg-yellow-500 text-white font-semibold py-1 px-2 rounded-md shadow-md hover:bg-yellow-600 transition duration-200 ease-in-out focus:outline-none focus:ring-2 focus:ring-yellow-500 focus:ring-opacity-50 dark:bg-yellow-600 dark:hover:bg-yellow-500"
              @click="editDoc(doc)"
            >
              แก้ไข
            </button>
            <button 
              class="bg-red-500 text-white font-semibold py-1 px-2 rounded-md shadow-md hover:bg-red-600 transition duration-200 ease-in-out focus:outline-none focus:ring-2 focus:ring-red-500 focus:ring-opacity-50 dark:bg-red-600 dark:hover:bg-red-500"
              @click="deleteDoc(doc.id)"
            >
              ลบ
            </button>
          </td>
        </tr>
      </tbody>
    </table>
    <p v-else>ไม่มีเอกสารสำหรับวิชานี้</p>
  </div>
</template>

<script>
export default {
  name: "AdminDoc",
  data() {
    return {
      subjects: [],
      docs: [],
      selectedSubject: '',
      fileName: '',
      fileLink: '',
      isEditing: false,
      currentDocId: null,
    };
  },
  watch: {
    selectedSubject(newSubject) {
      this.fetchDocsBySubject(newSubject);
    }
  },
  created() {
    this.fetchSubjects(); 
  },
  methods: {
    async fetchSubjects() {
      try {
        const response = await fetch(`${import.meta.env.VITE_APP_BASE_URL}/api/subjects`);
        if (!response.ok) throw new Error('Failed to fetch subjects');
        this.subjects = await response.json();
      } catch (error) {
        console.error("Error fetching subjects:", error);
      }
    },
    async fetchDocsBySubject(subjectCode) {
      if (!subjectCode) {
        this.docs = [];
        return;
      }

      try {
        const url = `${import.meta.env.VITE_APP_BASE_URL}/api/docs/doc-subject/${subjectCode}`;
        const response = await fetch(url);
        if (!response.ok) throw new Error(`Failed to fetch documents from ${url}`);
        this.docs = await response.json();
      } catch (error) {
        console.error("Error fetching documents:", error);
      }
    },
    async addDoc() {
      if (this.selectedSubject && this.fileName && this.fileLink) {
        try {
          const response = await fetch(`${import.meta.env.VITE_APP_BASE_URL}/api/doc`, {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json'
            },
            body: JSON.stringify({
              sub_code: this.selectedSubject,
              file_name: this.fileName,
              file_link: this.fileLink,
            })
          });
          if (!response.ok) throw new Error('Failed to add document');
          this.resetForm();
          this.fetchDocsBySubject(this.selectedSubject);
        } catch (error) {
          console.error("Error adding document:", error);
        }
      } else {
        alert("กรุณากรอกข้อมูลให้ครบถ้วน!");
      }
    },
    editDoc(doc) {
      this.selectedSubject = doc.sub_code;
      this.fileName = doc.file_name;
      this.fileLink = doc.file_link;
      this.currentDocId = doc.id;
      this.isEditing = true;
    },
    async updateDoc() {
      if (this.currentDocId && this.selectedSubject && this.fileName && this.fileLink) {
        try {
          const response = await fetch(`${import.meta.env.VITE_APP_BASE_URL}/api/doc/${this.currentDocId}`, {
            method: 'PUT',
            headers: {
              'Content-Type': 'application/json'
            },
            body: JSON.stringify({
              sub_code: this.selectedSubject,
              file_name: this.fileName,
              file_link: this.fileLink,
            })
          });
          if (!response.ok) throw new Error('Failed to update document');
          this.resetForm();
          this.fetchDocsBySubject(this.selectedSubject);
          this.isEditing = false;
        } catch (error) {
          console.error("Error updating document:", error);
        }
      } else {
        alert("กรุณากรอกข้อมูลให้ครบถ้วน!");
      }
    },
    async deleteDoc(docId) {
      if (confirm("คุณแน่ใจหรือไม่ว่าต้องการลบเอกสารนี้?")) {
        try {
          const response = await fetch(`${import.meta.env.VITE_APP_BASE_URL}/api/doc/${docId}`, {
            method: 'DELETE'
          });
          if (!response.ok) throw new Error('Failed to delete document');
          this.fetchDocsBySubject(this.selectedSubject);
        } catch (error) {
          console.error("Error deleting document:", error);
        }
      }
    },
    resetForm() {
      this.selectedSubject = '';
      this.fileName = '';
      this.fileLink = '';
      this.currentDocId = null;
      this.isEditing = false;
    },
  },
};
</script>

<style scoped>
/* Styles remain the same */
</style>
