<template>
  <aside
    :class="[
      'bg-white border-r h-screen sticky top-0 p-5 flex flex-col transition-all duration-300 ease-in-out',
      isCollapsed ? 'w-20' : 'w-64',
    ]"
  >
    <div class="flex items-center gap-3 mb-10">
      <div
        :class="[
          'rounded-xl flex items-center justify-center text-white shrink-0',
          isCollapsed ? 'w-8 h-8' : 'w-10 h-10',
          'bg-primary',
        ]"
      >
        <ShoppingBag :size="20" />
      </div>
      <div v-if="!isCollapsed" class="overflow-hidden">
        <p class="font-bold whitespace-nowrap">LaoShop</p>
        <!-- <p class="text-xs text-gray-500">Nuxt 3 Full Pack</p> -->
      </div>
    </div>

    <nav class="flex-1 space-y-2">
      <NuxtLink
        v-for="item in menu"
        :key="item.href"
        :to="item.href"
        :class="[
          'flex items-center gap-3 px-4 py-3 rounded-xl transition',
          isActive(item.href)
            ? 'bg-primary text-white'
            : 'text-gray-600 hover:bg-gray-50',
        ]"
        :title="isCollapsed ? item.label : undefined"
      >
        <component :is="item.icon" :size="18" class="shrink-0" />
        <span v-if="!isCollapsed" class="whitespace-nowrap">{{ item.label }}</span>
      </NuxtLink>
    </nav>

    <button
      @click="auth.logout()"
      class="flex items-center gap-3 px-4 py-3 text-gray-500 hover:bg-red-50 hover:text-red-600 rounded-xl mt-4"
      :title="isCollapsed ? 'ອອກຈາກລະບົບ' : undefined"
    >
      <LogOut :size="18" class="shrink-0" />
      <span v-if="!isCollapsed" class="whitespace-nowrap">ອອກຈາກລະບົບ</span>
    </button>
  </aside>
</template>

<script setup lang="ts">
import {
  LayoutDashboard,
  Package,
  Tag,
  ShoppingCart,
  Users,
  LogOut,
  ShoppingBag,
} from "lucide-vue-next";

const props = defineProps({
  collapsible: {
    type: Boolean,
    default: true,
  },
  collapsed: {
    type: Boolean,
    default: false,
  },
});

const emit = defineEmits<{
  (e: "update:collapsed", value: boolean): void;
}>();

const route = useRoute();
const auth = useAuthStore();

const isCollapsed = computed({
  get: () => props.collapsed,
  set: (value) => emit("update:collapsed", value),
});

const menu = [
  { href: "/", label: "Dashboard", icon: LayoutDashboard },
  { href: "/products", label: "ສິນຄ້າ", icon: Package },
  { href: "/categories", label: "ໝວດໝູ່", icon: Tag },
  { href: "/orders", label: "ອໍເດີ", icon: ShoppingCart },
  { href: "/customers", label: "ລູກຄ້າ", icon: Users },
];

const isActive = (href: string) => {
  if (href === "/") return route.path === "/";
  return route.path.startsWith(href);
};

onMounted(() => auth.init());
</script>