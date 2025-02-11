<template>
  <div>
    <div v-if="loading" class="text-center">กำลังโหลด...</div>
    <div v-else>
      <div class="grid grid-cols-2 gap-4 items-center mb-4">
        <label for="sub_code" class="text-left text-xl font-semibold">รหัสวิชา:</label>
        <span>{{ subject.sub_code || "ยังไม่มีข้อมูล" }}</span>

        <label for="sub_name" class="text-left text-xl font-semibold">ชื่อวิชา:</label>
        <span>{{ subject.sub_name || "ยังไม่มีข้อมูล" }}</span>

        <label for="sub_program" class="text-left text-xl font-semibold">สาขาวิชา:</label>
        <span>{{ subject.sub_program || "ยังไม่มีข้อมูล" }}</span>

        <label for="sub_unit" class="text-left text-xl font-semibold">หน่วยกิต:</label>
        <span>{{ subject.sub_unit || "ยังไม่มีข้อมูล" }}</span>
      </div>

      <!-- ส่วนเอกสารที่เกี่ยวข้อง -->
      <div class="mb-4 text-left">
        <h2 class="text-xl font-semibold mb-2">เอกสารที่เกี่ยวข้อง:</h2>
        <ul class="list-disc list-inside pl-4">
          <li
            v-for="file in files"
            :key="file.id"
            @click="downloadFile(file.file_link)"
            class="cursor-pointer text-blue-500 hover:underline"
          >
            {{ file.file_name }}
          </li>
        </ul>
      </div>

      <!-- ส่วน VDO ที่เกี่ยวข้อง -->
      <div class="mb-4 text-left">
        <h2 class="text-xl font-semibold mb-2">VDO ที่เกี่ยวข้อง:</h2>
        <ul class="list-none pl-0">
          <li
            v-for="vdo in vdos"
            :key="vdo.id"
            @click="openModal(vdo.vdo_link)"
            class="text-left cursor-pointer text-blue-500 hover:underline"
          >
            {{ vdo.vdo_name }}
          </li>
        </ul>
      </div>

      <!-- ปุ่มกลับ -->
      <button
        @click="goBack"
        class="bg-blue-500 text-white rounded-lg py-2 px-4 mb-4"
      >
        กลับ
      </button>

      <!-- Popup Modal สำหรับ VDO -->
      <div
        v-if="isModalOpen"
        class="fixed inset-0 flex items-center justify-center z-50 bg-black bg-opacity-50"
      >
        <div class="bg-white rounded-lg p-4 w-3/4 md:w-1/2">
          <h2 class="text-lg font-semibold mb-2">VDO Player</h2>
          <iframe
            v-if="videoProvider === 'youtube'"
            :src="currentVdoEmbedLink"
            frameborder="0"
            allowfullscreen
            class="w-full h-64"
          ></iframe>
          <iframe
            v-else
            :src="currentVdoEmbedLink"
            frameborder="0"
            allowfullscreen
            class="w-full h-64"
          ></iframe>
          <button
            @click="closeModal"
            class="mt-2 bg-red-500 text-white rounded-lg py-1 px-4"
          >
            ปิด
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from "axios";

export default {
  name: "SubjectDetail",
  data() {
    return {
      subject: {},
      files: [],
      vdos: [],
      loading: true,
      isModalOpen: false,
      currentVdoEmbedLink: "",
      videoProvider: "", // ระบุว่าเป็น YouTube หรือ Google Drive
    };
  },
  mounted() {
    const subCode = this.$route.params.sub_code;
    this.checkAuthentication();
    this.fetchSubjectDetail(subCode);
  },
  methods: {
    downloadFile(fileLink) {
      window.open(fileLink, '_blank');
    },
    checkAuthentication() {
      const isAuthenticated = localStorage.getItem("isAuthenticated") === "true";
      if (!isAuthenticated) {
        this.$router.push("/login"); // เปลี่ยนเส้นทางไปยังหน้า Login
      }
    },
    async fetchSubjectDetail(subCode) {
      const url = `${import.meta.env.VITE_APP_BASE_URL}/api/subjects/${subCode}`;
      try {
        const response = await axios.get(url);
        
        // ตรวจสอบว่าได้รับข้อมูลตามที่คาดหวัง
        if (response.data.success) {
          const { subject, documents, videos } = response.data.data;
          this.subject = subject;  // ข้อมูลของวิชา
          this.files = documents;   // เอกสารที่เกี่ยวข้อง
          this.vdos = videos;       // VDO ที่เกี่ยวข้อง
        } else {
          console.error("Failed to fetch subject details");
        }
      } catch (error) {
        console.error("Error fetching subject detail:", error);
      } finally {
        this.loading = false; // อัปเดตสถานะการโหลด
      }
    },
    openModal(vdoLink) {
      if (this.isYouTubeLink(vdoLink)) {
        const videoId = this.getYouTubeVideoId(vdoLink);
        this.currentVdoEmbedLink = `https://www.youtube.com/embed/${videoId}?enablejsapi=1`;
        this.videoProvider = "youtube"; // ระบุว่าเป็น YouTube
      } else if (this.isGoogleDriveLink(vdoLink)) {
        const fileId = this.getGoogleDriveFileId(vdoLink);
        this.currentVdoEmbedLink = `https://drive.google.com/file/d/${fileId}/preview`;
        this.videoProvider = "google"; // ระบุว่าเป็น Google Drive
      } else {
        alert("ลิงก์ไม่ถูกต้อง");
        return;
      }
      this.isModalOpen = true; // เปิด Modal
    },
    isYouTubeLink(url) {
      const youtubeRegex = /((youtube\.com\/watch\?v=)|(youtu\.be\/))/;
      return youtubeRegex.test(url);
    },
    isGoogleDriveLink(url) {
      const driveRegex = /drive\.google\.com/;
      return driveRegex.test(url);
    },
    getGoogleDriveFileId(url) {
      const regExp = /(?:drive\.google\.com\/.*?\/d\/|d\/|file\/d\/)(.*?)(?:\/|$)/;
      const match = url.match(regExp);
      return match ? match[1] : null;
    },
    closeModal() {
      this.isModalOpen = false;
      this.currentVdoEmbedLink = "";
    },
    getYouTubeVideoId(url) {
      const regExp = /^.*((youtu.be\/)|v\/|\/embed\/|watch\?v=)?([^&]{11}).*/;
      const match = url.match(regExp);
      return match && match[3] ? match[3] : null;
    },
    goBack() {
      this.$router.go(-1);
    },
  },
};
</script>

<style scoped>
/* Custom styles */
</style>