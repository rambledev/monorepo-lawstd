<template>
  <div class="flex items-center justify-between mt-4">
    <button 
      @click="changePage(current - 1)" 
      :disabled="current <= 1" 
      class="bg-custom text-white font-semibold py-1 px-2 rounded-md shadow-md hover:bg-purple-600 transition duration-200 ease-in-out focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-opacity-50 dark:bg-gray-700 dark:text-white dark:hover:bg-purple-600 dark:focus:ring-purple-500"
    >
      Prev
    </button>
    <span class="text-gray-700 dark:text-white">Page {{ current }} of {{ total }}</span>
    <button 
      @click="changePage(current + 1)" 
      :disabled="current >= total" 
      class="bg-custom text-white font-semibold py-1 px-2 rounded-md shadow-md hover:bg-purple-600 transition duration-200 ease-in-out focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-opacity-50 dark:bg-gray-700 dark:text-white dark:hover:bg-purple-600 dark:focus:ring-purple-500"
    >
      Next
    </button>
  </div>
</template>

<script>
export default {
  props: {
    total: {
      type: Number,
      required: true
    },
    current: {
      type: Number,
      required: true
    }
  },
  methods: {
    changePage(newPage) {
      this.$emit('pageChange', newPage);
    }
  }
};
</script>

<style>
.bg-custom {
  background-color: #e905f9; /* สีตามที่กำหนด */
}
.hover\:bg-purple-600:hover {
  background-color: #6b5b99; /* สีเมื่อ hover (ให้ปรับเปลี่ยนตามที่ต้องการ) */
}
</style>