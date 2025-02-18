<template>
  <div class="p-6 bg-gray-100 min-h-screen">
    <header class="bg-white shadow-md p-4 rounded-lg">
      <h1 class="text-2xl font-semibold">Dashboard</h1>
      <p class="text-gray-600">สรุปข้อมูลสำคัญของระบบ</p>
    </header>

    <section class="mt-6 grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
      <div v-for="(item, index) in summary" :key="index" class="bg-white p-4 rounded-lg shadow-md">
        <h2 class="text-lg font-medium">{{ item.title }}</h2>
        <p class="text-2xl font-bold text-blue-600">{{ item.value }}</p>
      </div>
    </section>

    <section class="mt-6 bg-white p-6 rounded-lg shadow-md">
      <h2 class="text-xl font-semibold mb-4">สถิติระบบ</h2>
      <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
        <div>
          <BarChart :chart-data="userChartData" />
        </div>
        <div>
          <BarChart :chart-data="courseViewChartData" />
        </div>
      </div>
    </section>
  </div>
</template>

<script>
import { defineComponent, ref, onMounted } from "vue";
import axios from "axios";
import { Chart, registerables } from "chart.js";
import { BarChart } from "vue-chart-3";

Chart.register(...registerables);

export default defineComponent({
  components: {
    BarChart,
  },
  setup() {
    const summary = ref([
      { title: "รายวิชาที่เปิด", value: 0 },
      { title: "ผู้เข้าใช้งาน", value: 0 },
      { title: "ข่าวที่เผยแพร่", value: 0 },
      { title: "รายการอัปโหลด", value: 0 },
    ]);

    const userChartData = ref({
      labels: [],
      datasets: [{ label: "ผู้ใช้งาน", backgroundColor: ["#3b82f6", "#10b981", "#f59e0b"], data: [] }],
    });

    const courseViewChartData = ref({
      labels: [],
      datasets: [{ label: "top 5 vdo", backgroundColor: ["#ef4444", "#22c55e", "#3b82f6", "#eab308"], data: [] }],
    });

    const fetchData = async () => {
      try {
        const baseURL = import.meta.env.VITE_APP_BASE_URL;

        // ดึงข้อมูลรายวิชาทั้งหมด
        const subjectsRes = await axios.get(`${baseURL}/api/dash/total-subjects`);
        summary.value[0].value = subjectsRes.data.total; 

        // ดึงข้อมูลผู้ใช้งาน
        const usersRes = await axios.get(`${baseURL}/api/dash/total-users`);
        summary.value[1].value = usersRes.data.total;

        // ดึงข้อมูลข่าวสาร
        const newsRes = await axios.get(`${baseURL}/api/dash/total-news`);
        summary.value[2].value = newsRes.data.total;

        // ดึงข้อมูลไฟล์อัปโหลดล่าสุด
        const uploadsRes = await axios.get(`${baseURL}/api/dash/total-uploads`);
        summary.value[3].value = uploadsRes.data.total ? `${uploadsRes.data.total} รายการ` : "ไม่มีข้อมูล";

        // ดึงข้อมูลสถิติผู้ใช้
        const userStatsRes = await axios.get(`${baseURL}/api/dash/usergraph`); // เปลี่ยนจาก /total-users เป็น /usergraph
        userChartData.value = {
          labels: userStatsRes.data.labels, // labels คือ admin, student, teacher
          datasets: [{ 
            label: "ผู้ใช้งาน",
            backgroundColor: ["#3b82f6", "#10b981", "#f59e0b"],
            data: userStatsRes.data.data // จำนวนผู้ใช้ในแต่ละประเภท
          }],
        };

        // ดึงข้อมูลการเข้าชมรายวิชา
        const courseViewRes = await axios.get(`${baseURL}/api/dash/vdograph`); // ดึงข้อมูลจาก /api/dash/vdograph
        courseViewChartData.value = {
          labels: courseViewRes.data.labels, // ชื่อวิชาที่เข้าชม
          datasets: [{ 
            label: "เข้าชม",
            backgroundColor: ["#ef4444", "#22c55e", "#3b82f6", "#eab308"], 
            data: courseViewRes.data.data // จำนวนการเข้าชม
          }],
        };
      } catch (error) {
        console.error("Error fetching dashboard data:", error);
      }
    };

    onMounted(fetchData);

    return { summary, userChartData, courseViewChartData };
  },
});
</script>

<style scoped></style>
