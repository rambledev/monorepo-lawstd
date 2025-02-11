<script setup>
import { useRouter } from 'vue-router'
import HelloWorld from './components/HelloWorld.vue'
import { ref } from 'vue';

const router = useRouter();
</script>

<template>
  <div>
    <!-- แทนที่ HelloWorld ด้วย router-view -->
    <router-view />
  </div>
</template>

<style scoped>
</style>