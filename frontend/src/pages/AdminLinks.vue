<template>
  <div class="p-4">
    <h1 class="text-3xl font-bold mb-4">ลิงค์ที่เกี่ยวข้อง</h1>

    <div v-if="showManageForm" class="mb-4">
      <h2 class="text-xl font-semibold mb-2">{{ editMode ? 'แก้ไข' : 'เพิ่ม' }} ลิงค์</h2>
      <form @submit.prevent="editMode ? updateLink() : addLink()">
        <input
          v-model="currentLink.name"
          placeholder="ชื่อลิงค์"
          required
          class="border rounded px-2 py-1 mb-2"
        />
        <input
          v-model="currentLink.link_url"
          placeholder="URL ของลิงค์ (ถ้ามี)"
          class="border rounded px-2 py-1 mb-2"
        />
        <select
          v-model="currentLink.level"
          required
          class="border rounded px-2 py-1 mb-2"
        >
          <option value="" disabled>ระดับ</option>
          <option v-for="i in 5" :key="i" :value="i">{{ i }}</option>
        </select>
        <input
          v-model.number="currentLink.parent_id"
          placeholder="ID ของ Parent (ถ้ามี)"
          class="border rounded px-2 py-1 mb-2"
        />
        <button
          type="submit"
          class="bg-blue-500 text-white rounded px-4 py-2"
        >บันทึก</button>
        <button
          @click="resetForms"
          class="bg-red-500 text-white rounded px-4 py-2"
        >ยกเลิก</button>
      </form>
    </div>

    <button @click="showManageForm = true" class="bg-blue-500 text-white rounded-lg py-2 px-4 mb-4">
      เพิ่มลิงค์ใหม่
    </button>

    <table class="min-w-full bg-white border border-gray-200">
      <thead>
        <tr>
          <th class="border px-4 py-2">id</th>
          <th class="border px-4 py-2">ชื่อหัวข้อ</th>
          <th class="border px-4 py-2">URL</th>
          <th class="border px-4 py-2">ระดับ</th>
          <th class="border px-4 py-2">ID ของ Parent</th>
          <th class="border px-4 py-2">ดำเนินการ</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="link in links" :key="link.id">
          <td class="border px-4 py-2">{{ link.id }}</td>
          <td class="border px-4 py-2">{{ link.name }}</td>
          <td class="border px-4 py-2">{{ link.link_url }}</td>
          <td class="border px-4 py-2">{{ link.level }}</td>
          <td class="border px-4 py-2">{{ link.parent_id }}</td>
          <td class="border px-4 py-2">
            <button @click="showEditForm(link)" class="text-blue-500 hover:underline bg-yellow-500 text-white rounded-lg py-2 px-4 ">แก้ไข</button>
            <button @click="deleteLink(link.id)" class="text-red-500 hover:underline bg-red-500 text-white rounded-lg py-2 px-4 ">ลบ</button>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  name: 'AdminLinks',
  data() {
    return {
      links: [],
      currentLink: { id: null, name: '', link_url: '', level: null, parent_id: null },
      showManageForm: false,
      editMode: false,
    };
  },
  mounted() {
    this.fetchLinks();
  },
  methods: {
    async fetchLinks() {
      try {
        const response = await axios.get(`${import.meta.env.VITE_APP_BASE_URL}/api/links`);
        this.links = response.data;
      } catch (error) {
        console.error('Error fetching links:', error);
      }
    },
    async addLink() {
      const newLink = {
        name: this.currentLink.name || null,
        link_url: this.currentLink.link_url || null,
        level: this.currentLink.level !== undefined ? this.currentLink.level : null,
        parent_id: this.currentLink.parent_id !== undefined ? this.currentLink.parent_id : null,
      };

      // Log for debugging
      console.log('Adding link with data:', newLink);

      try {
        const response = await axios.post(`${import.meta.env.VITE_APP_BASE_URL}/api/links`, newLink);
        this.links.push(response.data);
        this.resetForms();
      } catch (error) {
        console.error('Error adding link:', error.response ? error.response.data : error);
      }
    },
    showEditForm(link) {
      this.currentLink = { ...link };
      this.editMode = true;
      this.showManageForm = true;
    },
    async updateLink() {
      const updatedLink = {
        name: this.currentLink.name || null,
        link_url: this.currentLink.link_url || null,
        level: this.currentLink.level !== undefined ? this.currentLink.level : null,
        parent_id: this.currentLink.parent_id !== undefined ? this.currentLink.parent_id : null,
        id: this.currentLink.id
      };

      // Log for debugging
      console.log('Updating link with data:', updatedLink);

      try {
        await axios.put(`${import.meta.env.VITE_APP_BASE_URL}/api/links/${this.currentLink.id}`, updatedLink);
        this.fetchLinks();
        this.resetForms();
      } catch (error) {
        console.error('Error updating link:', error.response ? error.response.data : error);
      }
    },
    async deleteLink(id) {
      if (confirm('คุณแน่ใจหรือไม่ว่าต้องการลบลิงค์นี้?')) {
        try {
          await axios.delete(`${import.meta.env.VITE_APP_BASE_URL}/api/links/${id}`);
          this.fetchLinks();
        } catch (error) {
          console.error('Error deleting link:', error.response ? error.response.data : error);
        }
      }
    },
    resetForms() {
      this.currentLink = { id: null, name: '', link_url: '', level: null, parent_id: null };
      this.showManageForm = false;
      this.editMode = false;
    },
  },
};
</script>

<style scoped>
table {
  width: 100%;
  border-collapse: collapse;
}

th {
  background-color: #f4f4f4;
}

td {
  text-align: center;
}
</style>