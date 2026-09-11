<template>
  <div class="flex min-h-screen bg-[#f8f9fa]">
    <!-- Overlay -->
    <div
      v-if="isSidebarOpen"
      @click="toggleSidebar"
      class="fixed inset-0 bg-black/50 z-40 lg:hidden"
    ></div>

    <!-- Sidebar with transition -->
    <div
      :class="[
        'fixed lg:sticky top-0 left-0 h-screen z-50 transition-transform duration-300 ease-in-out',
        isSidebarOpen ? 'translate-x-0' : '-translate-x-full lg:translate-x-0',
      ]"
    >
      <Sidebar v-model:collapsed="isCollapsed" :collapsible="true" />
    </div>

    <!-- Main content -->
    <main class="flex-1 min-w-0">
      <!-- Header with hamburger button -->
      <header
        class="bg-white border-b px-4 py-3 flex items-center gap-3 sticky top-0 z-30"
      >
        <button
          @click="toggleSidebar"
          class="p-2 hover:bg-gray-100 rounded-lg lg:hidden"
        >
          <Menu :size="24" />
        </button>
        <button
          @click="toggleCollapse"
          class="p-2 hover:bg-gray-100 rounded-lg hidden lg:flex"
          :title="isCollapsed ? 'ຂະຫຍາຍ Sidebar' : 'ຫຍໍ້ Sidebar'"
        >
          <component :is="isCollapsed ? PanelLeftOpen : PanelLeftClose" :size="24" />
        </button>
        <slot name="header" />
      </header>

      <!-- Page content -->
      <div class="p-6">
        <slot />
      </div>
    </main>
  </div>
</template>

<script setup lang="ts">
import { Menu, PanelLeftOpen, PanelLeftClose } from "lucide-vue-next";

const isSidebarOpen = ref(false);
const isCollapsed = ref(false);

const toggleSidebar = () => {
  isSidebarOpen.value = !isSidebarOpen.value;
};

const toggleCollapse = () => {
  isCollapsed.value = !isCollapsed.value;
};

// Close sidebar when route changes
const route = useRoute();
watch(
  () => route.path,
  () => {
    isSidebarOpen.value = false;
  }
);
</script>