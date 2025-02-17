<template>
  <div class="p-4">
    <h1 class="text-3xl font-bold mb-4">ระบบสารสนเทศนักศึกษาคณะนิติศาสตร์</h1>

    <!-- 🔗 ลิ้งที่เกี่ยวข้อง -->
    <div>
      <h3 class="text-2xl font-semibold mb-2 text-left">ลิ้งที่เกี่ยวข้อง</h3>
      <ul class="list-none pl-0 text-left">
        <template v-for="link in groupedLinks" :key="link.id">
          <li>
            <div v-if="!link.link_url" class="cursor-pointer text-blue-500 hover:underline" @click="toggleSubItems(link.id)">
              {{ link.name }} <span v-if="link.subLinks.length">▼</span>
            </div>
            <a v-else :href="link.link_url" target="_blank" class="text-blue-500 hover:underline">
              {{ link.name }}
            </a>
            <ul v-if="isShowing[link.id]" class="ml-4 border-l pl-4">
              <template v-for="subLink in link.subLinks" :key="subLink.id">
                <li>
                  <div v-if="!subLink.link_url" class="cursor-pointer text-blue-500 hover:underline" @click="toggleSubItems(subLink.id)">
                    {{ subLink.name }} <span v-if="subLink.subLinks.length">▼</span>
                  </div>
                  <a v-else :href="subLink.link_url" target="_blank" class="text-blue-500 hover:underline">
                    {{ subLink.name }}
                  </a>
                  <ul v-if="isShowing[subLink.id]" class="ml-4 border-l pl-4">
                    <template v-for="childLink in subLink.subLinks" :key="childLink.id">
                      <li>
                        <a :href="childLink.link_url" target="_blank" class="text-blue-500 hover:underline">
                          {{ childLink.name }}
                        </a>
                      </li>
                    </template>
                  </ul>
                </li>
              </template>
            </ul>
          </li>
        </template>
      </ul>
    </div>

    <!-- 📰 ข่าวสาร -->
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
      this.links.forEach(link => {
        linkMap[link.id] = { ...link, subLinks: [] };
      });

      const rootLinks = [];
      this.links.forEach(link => {
        if (link.parent_id === null) {
          rootLinks.push(linkMap[link.id]);
        } else if (linkMap[link.parent_id]) {
          linkMap[link.parent_id].subLinks.push(linkMap[link.id]);
        }
      });
      this.groupedLinks = rootLinks;
    },

    toggleSubItems(id) {
      this.isShowing[id] = !this.isShowing[id];
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
