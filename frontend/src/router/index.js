import { createRouter, createWebHistory } from "vue-router";
import UserLayout from "../layouts/UserLayout.vue";
import AdminLayout from "../layouts/AdminLayout.vue";
import TeacherLayout from "../layouts/TeacherLayout.vue";
import Home from "../pages/Home.vue";
import Subject from "../pages/Subject.vue";
import Vdo from "../pages/Vdo.vue";
import AdminDashboard from "../pages/AdminDashboard.vue";
import AdminSubject from "../pages/AdminSubject.vue";
import AdminVdo from "../pages/AdminVdo.vue";
import AdminDoc from "../pages/AdminDoc.vue";
import AdminSubjectPermission from "../pages/AdminSubjectPermission.vue";
import AdminStdList from "../pages/AdminStdList.vue"; // นำเข้า component สำหรับหน้ารายชื่อนักศึกษา

import TeacherDashboard from "../pages/TeacherDashboard.vue";
import TeacherSubject from "../pages/TeacherSubject.vue";
import TeacherSubjectPermission from "../pages/TeacherSubjectPermission.vue";
import TeacherVdo from "../pages/TeacherVdo.vue";
import TeacherStdList from "../pages/TeacherStdList.vue";
import Login from "../pages/Login.vue"; // นำเข้าหน้า Login
import SubjectDetail from "../pages/SubjectDetail.vue"; // นำเข้า SubjectDetail
import AdminNews from "../pages/AdminNews.vue";
import AdminSubjectDetail from "../pages/AdminSubjectDetail.vue";
import AdminLinks from "../pages/AdminLinks.vue";
import NewsDetail from "../pages/NewsDetail.vue";
import DashboardEX from "../pages/DashboardEX.vue";


const routes = [
  {
    path: "/",
    redirect: "/home",
  },
  {
    path: "/",
    component: UserLayout,
    children: [
      { path: "home", component: Home },
      { path: "subject", component: Subject },
      { path: "vdo", component: Vdo },
      { path: "dex", component: DashboardEX },
      { 
        path: "subject-detail/:sub_code", // เส้นทางสำหรับ SubjectDetail
        name: 'SubjectDetail',
        component: SubjectDetail 
      },
      {
        name: "news-detail",
        path: "news-detail/:news_id",
        component: NewsDetail,
      },
    ],
  },
  {
    path: "/admin",
    component: AdminLayout,
    children: [
      { path: "dashboard", component: AdminDashboard },
      { path: "subject", component: AdminSubject },
      { path: "doc", component: AdminDoc },
      { path: "vdo", component: AdminVdo },
      { path: "permission", component: AdminSubjectPermission },
      { path: "news", component: AdminNews },
      { path: "links", component: AdminLinks },
      { 
        path: "studentslist/:subCode", // เส้นทางใหม่สำหรับหน้ารายชื่อนักศึกษา
        name: 'AdminStdList', 
        component: AdminStdList 
      },
    ],
  },
  {
    path: "/teacher",
    component: TeacherLayout,
    children: [
      { path: "dashboard", component: TeacherDashboard },
      { path: "subject", component: TeacherSubject },
      { path: "vdo", component: TeacherVdo },
      { path: "permission", component: TeacherSubjectPermission },
      { 
        path: "studentslist/:subCode", // เส้นทางใหม่สำหรับหน้ารายชื่อนักศึกษา
        name: 'TeacherStdList', 
        component: TeacherStdList 
      },
    ],
  },
  {
    path: "/login",  // เพิ่มเส้นทางสำหรับหน้า Login
    name: "Login",
    component: Login,
  },
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

// Guard เพื่อตรวจสอบการล็อกอิน
router.beforeEach((to, from, next) => {
  const isAuthenticated = localStorage.getItem('isAuthenticated') === 'true'; // ตรวจสอบสถานะล็อกอินจาก localStorage

  // ถ้าเป็น Home route ให้ไม่ต้องตรวจสอบการล็อกอิน
  if (to.path === '/home') {
    next(); // ไปต่อ
  }
  // ตรวจสอบเส้นทาง /admin
  else if (to.path.startsWith('/admin') && !isAuthenticated) {
    next('/login'); // ถ้าไม่ล็อกอิน ให้ไปหน้า login
  }
  // ตรวจสอบเส้นทาง /teacher
  else if (to.path.startsWith('/teacher') && !isAuthenticated) {
    next('/login'); // ถ้าไม่ล็อกอิน ให้ไปหน้า login
  } else {
    next(); // ถ้าล็อกอินแล้วหรือไม่เกี่ยวข้อง ให้ไปต่อ
  }
});

export default router;
