<template>
  <div class="p-4">
    <h1 class="text-3xl font-bold mb-4">ระบบสารสนเทศนักศึกษาคณะนิติศาสตร์</h1>

    <!-- ลิ้งที่เกี่ยวข้อง -->
    <div>
      <h3 class="text-2xl font-semibold mb-2 text-left">ลิ้งที่เกี่ยวข้อง</h3>
      <ul class="list-none pl-0 text-left">
        <li v-for="link in groupedLinks" :key="link.id" class="mb-2">
          <!-- ลิงก์หลัก -->
          <div class="cursor-pointer text-blue-500 hover:underline" 
               v-if="!link.link_url" 
               @click="toggleSubItems(link.id)">
            {{ link.name }} <span v-if="link.subLinks.length > 0">▼</span>
          </div>
          <div v-else>
              <a :href="link.link_url" target="_blank" class="text-blue-500 hover:underline">
                {{ link.name }}
              </a>
          </div>
          
          <!-- เมนูย่อย -->
          <ul v-if="isShowing[link.id]" class="ml-4 border-l pl-4">
            <li v-for="subLink in link.subLinks" :key="subLink.id">
              <a :href="subLink.link_url" class="text-blue-400 hover:underline" @click.prevent="openLink(subLink.link_url)">
                {{ subLink.name }}
              </a>
            </li>
          </ul>
        </li>
      </ul>
    </div>

    <!-- ข่าวสาร -->
    <div class="mt-8 text-left">
      <h2 class="text-2xl font-semibold mb-4">ข่าวสาร</h2>
      <div class="space-y-8">
        <div v-for="newsItem in news" :key="newsItem.id" class="border-b pb-4">
          <div class="flex justify-between">
            <div class="w-full">
              <div class="text-gray-500 text-sm mb-1">{{ formatDate(newsItem.created) }}</div>
              <h5 class="text-xl text-blue-600 cursor-pointer" @click="showNewsDetail(newsItem)">
                {{ newsItem.topic }}
              </h5>
            </div>
          </div>
          <button @click="showNewsDetail(newsItem)"
            class="mt-5 flex items-center text-white bg-blue-500 font-semibold rounded-lg p-2 hover:bg-blue-600 focus:outline-none">
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
import Swal from "sweetalert2";
import { useRouter } from 'vue-router';

export default {
  setup() {
    const router = useRouter();
    const showNewsDetail = (newsItem) => {
      router.push({ name: "news-detail", params: { news_id: newsItem.id } });
    };
    return { showNewsDetail };
  },

  name: "Home",
  data() {
    return {
      news: [],
      links: [],
      groupedLinks: [],
      isShowing: {},
      baseURL: import.meta.env.VITE_APP_BASE_URL,
    };
  },
  methods: {
    async fetchNews() {
      try {
        const response = await axios.get(`${this.baseURL}/api/news`);
        this.news = response.data;
      } catch (error) {
        console.error("Error fetching news:", error);
      }
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

    groupLinks() {
  const linkMap = {};
  
  // สร้าง linkMap เพื่อเก็บข้อมูลลิ้ง
  this.links.forEach(link => {
    linkMap[link.id] = { ...link, subLinks: [] };
  });

  // ค้นหาลิ้งตามระดับ
  this.groupedLinks = [];
  
  // เพิ่มลิ้งไปยัง groupedLinks ตลอดจน subLinks
  Object.values(linkMap).forEach(link => {
    if (link.parent_id === null) {
      this.groupedLinks.push(link); // ลิ้งหลัก (level 1)
    } else if (linkMap[link.parent_id]) {
      linkMap[link.parent_id].subLinks.push(link); // เพิ่มเป็น subLink
    }
  });

  // ฟังก์ชันสำหรับจัดเรียงระดับลิ้งที่แสดง
  const sortLinksByLevel = (links, level) => {
    links.forEach(link => {
      if (link.subLinks.length > 0) {
        // เรียงลำดับ subLinks
        sortLinksByLevel(link.subLinks, level + 1);
      }
    });

    // เรียงลำดับตาม level
    links.sort((a, b) => a.level - b.level);
  };

  // เรียงลำดับลิ้งหลัก (level 1)
  sortLinksByLevel(this.groupedLinks, 1);
},

    toggleSubItems(id) {
      this.isShowing[id] = !this.isShowing[id];
    },

    openLink(url) {
      if (url) window.open(url, "_blank");
    },

    formatDate(date) {
      return new Date(date).toLocaleDateString(undefined, { year: 'numeric', month: 'long', day: 'numeric' });
    },
  },
  mounted() {
    this.fetchNews();
    this.fetchLinks();
  },
};
</script>

<style scoped>
a {
  text-decoration: none;
}
</style>
