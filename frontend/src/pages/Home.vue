<template>
  <div class="p-4">
    <h1 class="text-3xl font-bold mb-4">ระบบสารสนเทศนักศึกษาคณะนิติศาสตร์</h1>

    <!-- ส่วนลิ้งที่เกี่ยวข้อง -->
    <div style="text-align: left; margin: 0;">
      <h3 class="text-2xl font-semibold mb-2">ลิ้งที่เกี่ยวข้อง</h3>
      <ul class="list-none p-0">
        <template v-for="(group, index) in groupedLinks" :key="index">
          <li v-if="group.level === 1" class="mb-2">
            <span
              v-if="group.link_url"
              @click="openLink(group.link_url)"
              class="text-lg font-bold cursor-pointer text-blue-600 hover:underline"
            >
              {{ group.name }}
            </span>
            <span
              v-else
              @click="toggleSubItems(group.id)"
              class="text-lg font-bold cursor-pointer"
            >
              {{ group.name }}
            </span>
            <ul v-if="group.subLinks.length > 0" class="ml-4 list-disc">
              <template v-for="subLink in group.subLinks" :key="subLink.id">
                <li>
                  <span
                    v-if="subLink.link_url"
                    @click="openLink(subLink.link_url)"
                    class="cursor-pointer text-md text-blue-600 hover:underline"
                  >
                    {{ subLink.name }}
                  </span>
                  <span
                    v-else
                    @click="toggleSubItems(subLink.id)"
                    class="cursor-pointer text-md"
                  >
                    {{ subLink.name }}
                  </span>
                  <ul v-if="isShowing[subLink.id]" class="ml-4 list-disc">
                    <li v-for="subSubLink in subLink.subLinks" :key="subSubLink.id">
                      <a
                        :href="subSubLink.link_url || '#'"
                        target="_blank"
                        rel="noopener noreferrer"
                        class="text-blue-600 hover:underline"
                      >
                        {{ subSubLink.name }}
                      </a>
                    </li>
                  </ul>
                </li>
              </template>
            </ul>
          </li>
        </template>
      </ul>
    </div>

    <!-- ส่วนข่าวสาร -->
    <div class="mt-8">
      <h2 class="text-2xl font-semibold mb-4">ข่าวสาร</h2>
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
        <div
          class="border rounded shadow cursor-pointer"
          v-for="newsItem in news"
          :key="newsItem.id"
          @click="showNewsDetail(newsItem)"
        >
          <img :src="newsItem.img1 || baseImageUrl" alt="Thumbnail" class="w-full h-auto rounded-t" />
          <div class="p-4">
            <label class="text-xl w-full overflow-hidden break-words whitespace-normal">
  {{ newsItem.topic }}
</label>



          </div>
        </div>
      </div>
    </div>

  </div>
</template>

<script>
import axios from "axios";
import baseImage from "../assets/hotnews.jpg";
import Swal from "sweetalert2"; // นำเข้า SweetAlert2

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
            ${newsItem.img1 ? `<img src="${newsItem.img1}" style="width: 100px; margin: 5px;" />` : ''}
            ${newsItem.img2 ? `<img src="${newsItem.img2}" style="width: 100px; margin: 5px;" />` : ''}
            ${newsItem.img3 ? `<img src="${newsItem.img3}" style="width: 100px; margin: 5px;" />` : ''}
            ${newsItem.img4 ? `<img src="${newsItem.img4}" style="width: 100px; margin: 5px;" />` : ''}
            ${newsItem.img5 ? `<img src="${newsItem.img5}" style="width: 100px; margin: 5px;" />` : ''}
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