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
import { defineComponent, ref } from "vue";
import { Chart, registerables } from "chart.js";
import { BarChart } from "vue-chart-3";

Chart.register(...registerables);

export default defineComponent({
  components: {
    BarChart,
  },
  setup() {
    const summary = ref([
      { title: "รายวิชาที่เปิด", value: 12 },
      { title: "ผู้เข้าใช้งาน", value: 350 },
      { title: "ข่าวที่เผยแพร่", value: 8 },
      { title: "อัปโหลดล่าสุด", value: "5 รายการ" },
    ]);

    const userChartData = ref({
      labels: ["นักเรียน", "อาจารย์", "บุคลากร"],
      datasets: [{ label: "ผู้ใช้งาน", backgroundColor: ["#3b82f6", "#10b981", "#f59e0b"], data: [250, 70, 30] }],
    });

    const courseViewChartData = ref({
      labels: ["Math", "Science", "History", "English"],
      datasets: [{ label: "เข้าชม", backgroundColor: ["#ef4444", "#22c55e", "#3b82f6", "#eab308"], data: [120, 200, 150, 180] }],
    });

    return { summary, userChartData, courseViewChartData };
  },
});
</script>

<style scoped></style>
