<template>
    <div>
      <div v-if="news">
        
        <h1 class="text-2xl font-bold text-left">{{ news.topic }}</h1>
        <p class="text-gray-700 text-left">{{ news.detail }}</p>
  
        <div v-if="newsImages.length > 0" class="grid grid-cols-2 md:grid-cols-3 gap-4">
          <img 
            v-for="(image, index) in newsImages" 
            :key="index" 
            :src="image" 
            alt="News Image" 
            class="rounded-lg shadow-md cursor-pointer"
            @click="openModal(image)"
          />
        </div>
      </div>
      <div v-else>
        <p>Loading...</p>
      </div>
  
      <!-- Modal -->
      <div v-if="isModalOpen" class="fixed inset-0 flex items-center justify-center bg-black bg-opacity-75 z-50" @click="closeModal">
        <div class="relative">
          <button @click="closeModal" class="absolute top-2 right-2 text-white bg-black bg-opacity-50 rounded-full p-2 hover:bg-opacity-75 focus:outline-none">
            &times; <!-- ตัวอักษรกากบาท -->
          </button>
          <img :src="currentImage" class="max-w-full max-h-full transform transition-transform duration-300 ease-in-out" @click.stop />
        </div>
      </div>
      <div class="text-center">
        <button @click="goBack" class="mt-5 flex items-center text-white bg-blue-500 font-semibold rounded-lg p-2 hover:bg-blue-600 focus:outline-none">
          <span class="material-icons"></span> 
          กลับ
        </button>
      </div>
    </div>

    
  </template>
  
  <script>
  import { useRoute, useRouter } from "vue-router";
  import axios from "axios";
  
  export default {
    name: "NewsDetail",
    data() {
      return {
        news: null,
        baseURL: import.meta.env.VITE_APP_BASE_URL,
        path_uploads: "/uploads",
        isModalOpen: false,
        currentImage: "",
        newsImages: [],
      };
    },
    async mounted() {
      await this.fetchNews();
    },
    methods: {
      async fetchNews() {
        const route = useRoute();
        const newsId = route.params.news_id; 
        try {
          const response = await axios.get(`${this.baseURL}/api/news/${newsId}`);
          this.news = response.data; 
          this.newsImages = [this.news.img1, this.news.img2, this.news.img3, this.news.img4, this.news.img5]
            .filter((img) => img)
            .map((img) => `${this.path_uploads}/${img}`);
        } catch (error) {
          console.error("Error fetching news:", error);
        }
      },
      openModal(image) {
        this.currentImage = image;
        this.isModalOpen = true;
      },
      closeModal() {
        this.isModalOpen = false;
      },
      goBack() {
        this.$router.push('/home'); // กลับไปหน้าหลัก
      },
    },
  };
  </script>
  
  <style scoped>
  .fixed {
    position: fixed;
  }
  .bg-black {
    background-color: rgba(0, 0, 0, 0.75);
  }
  .max-w-full {
    max-width: 100%;
  }
  .max-h-full {
    max-height: 100%;
  }
  .cursor-pointer {
    cursor: pointer;
  }
  </style>