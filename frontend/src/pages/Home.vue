<template>
  <div class="p-4">
    <h1 class="text-3xl font-bold mb-4">ระบบสารสนเทศนักศึกษาคณะนิติศาสตร์</h1>

    <div class="mt-8">
      <h2 class="text-2xl font-semibold mb-4">ข่าวสาร</h2>
      <div class="space-y-8">
        <div
          v-for="newsItem in news"
          :key="newsItem.id"
          class="border-b pb-4"
        >
          <div class="flex justify-between">
            <div>
              <div class="text-gray-500 text-sm mb-1">{{ formatDate(newsItem.createdAt) }}</div>
              <h3 class="text-xl font-semibold text-blue-600 hover:underline cursor-pointer" @click="showNewsDetail(newsItem)">
                {{ newsItem.topic }}
              </h3>
              <!-- <p class="text-gray-700 mt-1">{{ newsItem.detail.slice(0, 100) }}...</p> -->
            </div>
            <!-- <div class="w-1/3">
              <img :src="`${path_uploads}/${newsItem.img1}`" alt="Thumbnail" class="w-full h-auto rounded-md" v-if="newsItem.img1" />
            </div> -->
          </div>
          <button
            @click="showNewsDetail(newsItem)"
            class="mt-2 text-blue-500 font-semibold hover:underline"
          >
            Read more →
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from "axios";
import baseImage from "../assets/hotnews.jpg";
import Swal from "sweetalert2"; // นำเข้า SweetAlert2
const path_uploads = "/uploads"; // กำหนด path โดยตรง

export default {
  name: "Home",
  data() {
    return {
      news: [],
      links: [],
      groupedLinks: [],
      baseURL: import.meta.env.VITE_APP_BASE_URL,
      baseImageUrl: baseImage, // กำหนด base image URL ที่นี่
      isShowing: {},
      path_uploads: path_uploads,
    };
  },
  methods: {
    async fetchNews() {
      try {
        const response = await axios.get(`${this.baseURL}/api/news`);
        this.news = response.data;
        console.log("Fetched news:", this.news);
      } catch (error) {
        console.error("Error fetching news:", error);
      }
    },

    formatDate(date) {
      const options = { year: 'numeric', month: 'long', day: 'numeric' };
      return new Date(date).toLocaleDateString(undefined, options);
    },

    groupLinks() {
      const linkMap = {};
      this.links.forEach((link) => {
        linkMap[link.id] = {
          id: link.id,
          name: link.name,
          level: link.level,
          parent_id: link.parent_id,
          link_url: link.link_url,
          subLinks: [],
        };
      });

      Object.values(linkMap).forEach((link) => {
        if (link.parent_id !== null) {
          linkMap[link.parent_id].subLinks.push(link);
        } else {
          this.groupedLinks.push(link);
        }
      });
    },
    
    async fetchLinks() {
      try {
        const response = await axios.get(`${this.baseURL}/api/links`);
        this.links = response.data;
        this.groupLinks();
      } catch (error) {
        console.error("Error fetching links:", error);
      }
    },
    
    openLink(url) {
      if (url) {
        window.open(url, "_blank");
      }
    },
    toggleSubItems(id) {
      this.isShowing[id] = !this.isShowing[id];
    },
    showNewsDetail(newsItem) {
      Swal.fire({
        title: newsItem.topic,
        html: `
          <p>${newsItem.detail}</p>
          <div class="news-images" style="display: flex; flex-wrap: wrap;">
            ${newsItem.img1 ? `<img src="${path_uploads}/${newsItem.img1}" style="width: 100px; margin: 5px;" />` : ''}
            ${newsItem.img2 ? `<img src="${path_uploads}/${newsItem.img2}" style="width: 100px; margin: 5px;" />` : ''}
            ${newsItem.img3 ? `<img src="${path_uploads}/${newsItem.img3}" style="width: 100px; margin: 5px;" />` : ''}
            ${newsItem.img4 ? `<img src="${path_uploads}/${newsItem.img4}" style="width: 100px; margin: 5px;" />` : ''}
            ${newsItem.img5 ? `<img src="${path_uploads}/${newsItem.img5}" style="width: 100px; margin: 5px;" />` : ''}
          </div>
        `,
        showCloseButton: true,
        showCancelButton: true,
        focusConfirm: false,
        confirmButtonText: 'ตกลง',
        cancelButtonText: 'ปิด',
      });
    },
  },
  mounted() {
    this.fetchNews();
    this.fetchLinks();
    console.log("Base URL:", this.baseURL);
  },
};
</script>

<style scoped>
/* คุณสามารถเพิ่ม CSS เพิ่มเติมที่นี่ */
</style>