<template>
  <div class="bg-white dark:bg-gray-900 text-gray-900 dark:text-white">
    <h2 class="text-2xl font-bold mb-4">จัดการข่าว</h2>
    <div>
      <div class="form-group">
        <label for="newsTitle" class="font-semibold">หัวข้อข่าว:</label>
        <input
          style="width:50%"
          type="text"
          v-model="newsTitle"
          id="newsTitle"
          placeholder="หัวข้อข่าว"
          class="border border-gray-300 rounded-md p-2 dark:bg-gray-800 dark:border-gray-600 dark:text-white"
        />
      </div>
      <br />
      <div class="form-group">
        <label for="newsContent" class="font-semibold">รายละเอียดข่าว:</label>
        <textarea
          style="width:50%"
          v-model="newsContent"
          id="newsContent"
          rows="5"
          placeholder="รายละเอียดข่าว"
          class="border border-gray-300 rounded-md p-2 dark:bg-gray-800 dark:border-gray-600 dark:text-white"
        ></textarea>
      </div>
      <br />
      <div class="form-group">
        <label for="newsAuthor" class="font-semibold">ผู้เขียน:</label>
        <input
          style="width:50%"
          type="text"
          v-model="newsAuthor"
          id="newsAuthor"
          placeholder="ชื่อผู้เขียน"
          value="admin"
          class="border border-gray-300 rounded-md p-2 dark:bg-gray-800 dark:border-gray-600 dark:text-white"
        />
      </div>
      <br />

      <!-- แสดงรูปภาพที่มีอยู่หากมีข้อมูล -->
      <div v-if="isEditing">
        <div v-if="currentNewsImages.length > 0" class="mb-4">
          <h4 class="font-semibold mb-2">รูปภาพที่อัปโหลด:</h4>
          <div class="flex space-x-4">
            <div v-for="(img, index) in currentNewsImages" :key="index" class="relative">
              <img :src="`${baseURL}/uploads/${img}`" alt="Image" class="w-20 h-20 object-cover mb-2" />
              <button
                @click="deleteImage(index)"
                class="absolute top-0 right-0 bg-red-500 text-white rounded-full p-1 text-xs"
              >
                X
              </button>
              
            </div>
          </div>
        </div>
      </div>

      <div class="form-group">
        <label class="font-semibold">อัปโหลดรูปภาพ:</label>
        <div v-for="index in 5" :key="index">
          <input
            type="file"
            accept="image/*"
            @change="handleFileUpload($event, index)"
            class="block mb-2 dark:text-white"
          />
          <div v-if="index === 1" class="text-sm text-gray-700">
            * รูปภาพที่ 1 จะใช้เป็นรูป หน้าปกข่าว
          </div>
          <div v-if="imgDetails[index - 1]" class="text-sm text-gray-700">
            ขนาด: {{ imgDetails[index - 1].size }} KB, นามสกุล: {{ imgDetails[index - 1].type }}
          </div>
        </div>
      </div>
      <br />
      <button
        class="bg-blue-500 text-white font-semibold py-2 px-4 rounded-md shadow-md hover:bg-blue-600 transition duration-200 ease-in-out focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-opacity-50 dark:bg-blue-700 dark:hover:bg-blue-600 dark:focus:ring-blue-400"
        @click="isEditing ? updateNews() : addNews()"
      >
        {{ isEditing ? 'บันทึก' : 'เพิ่มข่าว' }}
      </button>
    </div>

    <h3 class="text-xl font-semibold mt-6">รายการข่าว</h3>
    <table class="table-auto w-full mt-4 border-collapse border border-gray-300 dark:border-gray-700" v-if="newsList.length > 0">
      <thead>
        <tr class="bg-gray-100 dark:bg-gray-800">
          <th class="border px-4 py-2 dark:text-white">หัวข้อข่าว</th>
          <th class="border px-4 py-2 dark:text-white">รายละเอียด</th>
          <th class="border px-4 py-2 dark:text-white">รูปภาพ</th>
          <th class="border px-4 py-2 dark:text-white">Actions</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="news in newsList" :key="news.id" class="hover:bg-gray-50 dark:hover:bg-gray-700">
          <td class="border px-4 py-2">{{ news.topic }}<br><br><br>ผู้เขียน: {{ news.author }}</td>
          <td class="border px-4 py-2">{{ news.detail }}</td>
          <td class="border px-4 py-2">
            <div v-if="news.img1">
              <img :src="`${path_uploads}/${news.img1}`" alt="Image 1" class="w-20 h-20 object-cover" />
            </div>
            <div v-if="news.img2">
              <img :src="`${path_uploads}/${news.img2}`" alt="Image 2" class="w-20 h-20 object-cover" />
            </div>
            <div v-if="news.img3">
              <img :src="`${path_uploads}/${news.img3}`" alt="Image 3" class="w-20 h-20 object-cover" />
            </div>
            <div v-if="news.img4">
              <img :src="`${path_uploads}/${news.img4}`" alt="Image 4" class="w-20 h-20 object-cover" />
            </div>
            <div v-if="news.img5">
              <img :src="`${path_uploads}/${news.img5}`" alt="Image 5" class="w-20 h-20 object-cover" />
            </div>
          </td>
          <td class="border px-4 py-2 text-center">
            <button
              class="bg-yellow-500 text-white font-semibold py-1 px-2 rounded-md shadow-md hover:bg-yellow-600 transition duration-200 ease-in-out focus:outline-none focus:ring-2 focus:ring-yellow-500 focus:ring-opacity-50 dark:bg-yellow-600 dark:hover:bg-yellow-500"
              @click="editNews(news)"
            >
              แก้ไข
            </button>
            <button
              class="bg-red-500 text-white font-semibold py-1 px-2 rounded-md shadow-md hover:bg-red-600 transition duration-200 ease-in-out focus:outline-none focus:ring-2 focus:ring-red-500 focus:ring-opacity-50 dark:bg-red-600 dark:hover:bg-red-500"
              @click="deleteNews(news.id)"
            >
              ลบ
            </button>
          </td>
        </tr>
      </tbody>
    </table>
    <p v-else>ไม่มีข่าวในระบบ</p>
  </div>
</template>

<script>
import axios from "axios";
const baseURL = import.meta.env.VITE_APP_BASE_URL;
const path_uploads = "/uploads"; // กำหนด path โดยตรง
console.log("base_url = "+baseURL);
console.log("path_upload="+path_uploads);
export default {
  name: "AdminNews",
  data() {
    return {
      baseURL: baseURL,
      path_uploads: path_uploads,
      newsList: [],
      newsTitle: "",
      newsContent: "",
      newsAuthor: "",
      imgFiles: [],
      imgDetails: Array(5).fill(null), // Array to hold image details
      currentNewsImages: [],
      isEditing: false,
      currentNewsId: null,
    };
  },
  created() {
    this.fetchNews();
  },
  methods: {
    async fetchNews() {
      try {
        const response = await axios.get(`${this.baseURL}/api/news`);
        this.newsList = response.data;


        


      } catch (error) {
        console.error("Error fetching news:", error);
      }
    },
    async addNews() {
      const formData = new FormData();
      formData.append('topic', this.newsTitle);
      formData.append('detail', this.newsContent);
      formData.append('author', this.newsAuthor);
      this.imgFiles.forEach((file, index) => {
        if (file) formData.append(`img${index + 1}`, file);
      });

      try {
        const response = await axios.post(`${this.baseURL}/api/news`, formData, {
          headers: {
              'Content-Type': 'multipart/form-data'
          }
        });
        // Handle success
        console.log('News added:', response.data);
        this.resetForm();
        this.fetchNews();
      } catch (error) {
        console.error('Error adding news:', error);
      }
    },
    handleFileUpload(event, index) {
      const file = event.target.files[0];
      this.imgFiles[index - 1] = file;

      if (file) {
        const sizeInKB = (file.size / 1024).toFixed(2);
        const type = file.type.split('/')[1];

        this.imgDetails[index - 1] = { size: sizeInKB, type: type };
      } else {
        this.imgDetails[index - 1] = null;
      }
    },
    resetForm() {
      this.newsTitle = "";
      this.newsContent = "";
      this.newsAuthor = "";
      this.imgFiles = [];
      this.imgDetails = Array(5).fill(null);
      this.currentNewsId = null;
      this.isEditing = false;
      this.currentNewsImages = [];
    },
    editNews(news) {
      this.newsTitle = news.topic;
      this.newsContent = news.detail;
      this.newsAuthor = news.author;
      this.currentNewsId = news.id;
      this.isEditing = true;
      this.currentNewsImages = [news.img1, news.img2, news.img3, news.img4, news.img5].filter(Boolean);
      this.currentNewsImages.forEach(img => {
        console.log(`Image URL: ${this.baseURL}/uploads/${img}`);
      });
    },
    async updateNews() {
      const formData = new FormData();
      formData.append('topic', this.newsTitle);
      formData.append('detail', this.newsContent);
      formData.append('author', this.newsAuthor);

      this.imgFiles.forEach((file, index) => {
        if (file) formData.append(`img${index + 1}`, file);
      });

      try {
        const response = await axios.put(`${this.baseURL}/api/news/${this.currentNewsId}`, formData, {
          headers: { 'Content-Type': 'multipart/form-data' }
        });
        console.log('News updated:', response.data);
        this.resetForm();
        this.fetchNews();
      } catch (error) {
        console.error('Error updating news:', error);
      }
    },
    async deleteNews(id) {
      try {
        await axios.delete(`${this.baseURL}/api/news/${id}`);
        this.fetchNews();
      } catch (error) {
        console.error("Error deleting news:", error);
      }
    },
    deleteImage(index) {
      this.currentNewsImages.splice(index, 1);
      this.imgFiles[index] = null; // Clear the associated file from imgFiles
    }
  },
};
</script>

<style scoped>
/* คุณสามารถเพิ่ม CSS เพิ่มเติมที่นี่ */
</style>