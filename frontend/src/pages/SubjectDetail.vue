<template>
  <div>
    <div v-if="loading" class="text-center">กำลังโหลด...</div>
    <div v-else>
      <div class="grid grid-cols-2 gap-4 items-center mb-4">
        <span for="sub_code" class="text-left font-semibold">รหัสวิชา:</span>
        <span>{{ subject.sub_code || "ยังไม่มีข้อมูล" }}</span>

        <span for="sub_name" class="text-left font-semibold">ชื่อวิชา:</span>
        <span>{{ subject.sub_name || "ยังไม่มีข้อมูล" }}</span>

        <span for="sub_program" class="text-left font-semibold">อาจารย์ผู้สอน:</span>
        <span>{{ subject.sub_teacher || "ยังไม่มีข้อมูล" }}</span>

        <span for="sub_unit" class="text-left font-semibold">หน่วยกิต:</span>
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
            @click="openModal(vdo.vdo_link,vdo.id)"
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
import Swal from "sweetalert2"; // เพิ่ม SweetAlert

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
      userProfile: null,
      std_code: "",  // เก็บค่า std_code ที่จะใช้งานในคอมโพเนนต์
    };
  },
  mounted() {
    // ดึงข้อมูล userProfile จาก localStorage
    const userProfile = JSON.parse(localStorage.getItem('userProfile'));
    
    if (userProfile) {
      console.log("User Profile:", userProfile);
      this.userProfile = userProfile;
      this.std_code = userProfile.USERCODE;  // กำหนดค่า std_code จาก userProfile
    } else {
      console.log("User profile not found.");
    }

    const subCode = this.$route.params.sub_code;
    this.checkAuthentication();
    this.fetchSubjectDetail(subCode);
  },
  methods: {
    downloadFile(fileLink) {
      const isAuthenticated = localStorage.getItem("isAuthenticated") === "true";
      console.log("checkAuthen = " + isAuthenticated);
      if (!isAuthenticated) {
        this.$router.push("/login"); // เปลี่ยนเส้นทางไปยังหน้า Login ถ้าไม่ได้ล็อกอิน
      }

      window.open(fileLink, '_blank');
    },
    checkAuthentication() {
      const isAuthenticated = localStorage.getItem("isAuthenticated") === "true";
      if (!isAuthenticated) {
        this.$router.push("/login"); // เปลี่ยนเส้นทางไปยังหน้า Login
      }
    },
    async fetchSubjectDetail(subCode) {
      // ล้างค่า subCode
      const cleanSubCode = decodeURIComponent(subCode).trim();
      const url = `${import.meta.env.VITE_APP_BASE_URL}/api/subjects/sub-data/${cleanSubCode}`;
      
      console.log("url api =", url); // ตรวจสอบค่า
      
      try {
        const response = await axios.get(url);
        
        if (response.data.success) {
          const { subject, documents, videos } = response.data.data;
          this.subject = subject;
          
          // ตรวจสอบ permission
          await this.checkPermissionSub(subject.sub_code);

          this.files = documents ? [documents] : []; // ปรับให้เป็น array
          this.vdos = videos ? [videos] : [];       // ปรับให้เป็น array
        } else {
          console.error("Failed to fetch subject details");
        }
      } catch (error) {
        console.error("Error fetching subject detail:", error);
      } finally {
        this.loading = false; 
      }
    },

    async checkPermissionSub(subCode) {
      try {
  const response = await axios.get(`${import.meta.env.VITE_APP_BASE_URL}/api/subjects/checkPerSub/${this.std_code}/${subCode}`);

  // เช็คว่า status เป็น inactive หรือมี error message ว่า "No permission data found for this subject and student"
  if (response.data.status === "inactive" || response.data.error === "No permission data found for this subject and student") {
    Swal.fire({
      title: 'ไม่มีสิทธิ์เข้าถึงรายวิชานี้',
      icon: 'error',
      confirmButtonText: 'OK'
    }).then(() => {
      this.$router.push("/subject"); // ไปยังหน้า /subject เมื่อกด OK
    });
  }
} catch (error) {
  console.error("Error checking permission:", error);
}

    },

    openModal(vdoLink, vdoId) {
      const isAuthenticated = localStorage.getItem("isAuthenticated") === "true";
      console.log("checkAuthen = " + isAuthenticated);
      
      if (!isAuthenticated) {
        this.$router.push("/login"); // เปลี่ยนเส้นทางไปยังหน้า Login ถ้าไม่ได้ล็อกอิน
        return;
      }

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

      // ใช้ std_code จาก userProfile
      console.log("stdCode = " + this.std_code);
      this.recordView(vdoId, this.std_code);

      this.isModalOpen = true; // เปิด Modal
    },

    // ฟังก์ชันบันทึกยอดวิว
    async recordView(vdoId, stdCode) {
      try {
        const response = await fetch(`${import.meta.env.VITE_APP_BASE_URL}/api/vdos/vdo/view`, {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
  },
  body: JSON.stringify({ vdo_id: vdoId, std_code: stdCode }),
});

if (response.ok) {
  const data = await response.json();
  console.log(data.message);  // จะแสดงข้อความ 'View recorded successfully'
} else {
  console.log('เกิดข้อผิดพลาดในการบันทึกยอดวิว');
}

      } catch (error) {
        console.error('เกิดข้อผิดพลาดในการเรียก API:', error);
      }
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
