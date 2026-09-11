<template>
  <div class="p-8">
    <div class="flex items-center justify-between mb-6">
      <h1 class="text-2xl font-bold flex items-center gap-2">
        <Package /> ຈັດການສິນຄ້າ
      </h1>
      <button @click="openCreate" class="btn-primary flex items-center gap-2">
        <Plus :size="18" /> ເພີ່ມສິນຄ້າ
      </button>
    </div>

    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
      <div v-for="p in paginatedProducts" :key="p.id" class="card hover:shadow-md transition">
        <div class="flex gap-4">
          <NuxtImg :src="fullImageUrl(p.images?.[0])" width="80" height="80" class="rounded-xl object-cover"
            format="webp" />
          <div class="flex-1 min-w-0">
            <p class="font-bold flex items-center gap-2 truncate">
              <Tag :size="12" /> {{ p.name }}
            </p>
            <p class="text-sm text-gray-500 line-clamp-2">
              {{ p.description }}
            </p>
            <p class="text-primary font-bold mt-1 flex items-center gap-1">
              <DollarSign :size="12" /> ${{ p.price }}
            </p>
            <p class="text-xs text-gray-400 flex items-center gap-1">
              <Calendar :size="10" />
              {{ dayjs(p.createdAt).format("DD/MM/YYYY") }} | Stock:
              {{ p.stock }}
            </p>
          </div>
        </div>
        <div class="flex gap-2 mt-3">
          <button @click="openEdit(p)" class="btn-secondary text-sm flex-1 flex items-center justify-center gap-1">
            <Edit :size="12" /> ແກ້ໄຂ
          </button>
          <button @click="deleteProduct(p.id)"
            class="bg-red-50 text-red-600 px-4 py-2 rounded-xl text-sm flex-1 flex items-center justify-center gap-1">
            <Trash2 :size="12" /> ລົບ
          </button>
        </div>
      </div>
    </div>

    <!-- Empty state -->
    <div v-if="paginatedProducts.length === 0" class="text-center text-gray-400 py-12">
      ບໍ່ມີສິນຄ້າ
    </div>

    <!-- Pagination -->
    <div v-if="totalPages > 1" class="flex items-center justify-center gap-2 mt-8">
      <button @click="prevPage" :disabled="currentPage === 1"
        class="p-2 rounded-lg border hover:bg-gray-50 disabled:opacity-40 disabled:cursor-not-allowed">
        <ChevronLeft :size="18" />
      </button>

      <button v-for="page in visiblePages" :key="page" @click="goToPage(page)" :class="[
        'w-9 h-9 rounded-lg border text-sm font-medium transition',
        page === currentPage
          ? 'bg-primary text-white border-primary'
          : 'hover:bg-gray-50',
      ]">
        {{ page }}
      </button>

      <button @click="nextPage" :disabled="currentPage === totalPages"
        class="p-2 rounded-lg border hover:bg-gray-50 disabled:opacity-40 disabled:cursor-not-allowed">
        <ChevronRight :size="18" />
      </button>
    </div>

    <!-- Modal -->
    <Teleport to="body">
      <Transition name="fade">
        <div v-if="isModalOpen" @click.self="closeModal"
          class="fixed inset-0 bg-black/50 z-50 flex items-center justify-center p-4">
          <div class="bg-white rounded-2xl w-full max-w-lg max-h-[90vh] overflow-y-auto p-6 shadow-xl">
            <div class="flex items-center justify-between mb-4">
              <h3 class="font-bold flex items-center gap-2">
                <Plus :size="18" />
                {{ editingId ? "ແກ້ໄຂສິນຄ້າ" : "ເພີ່ມສິນຄ້າ" }}
              </h3>
              <button @click="closeModal" class="p-1 hover:bg-gray-100 rounded-lg">
                <X :size="20" />
              </button>
            </div>
            <p class="text-xs bg-violet-50 text-violet-700 p-2 rounded-lg mb-4 flex items-center gap-1">
              <ShieldCheck :size="12" /> Zod + VeeValidate
            </p>

            <form @submit="onSubmit" class="space-y-3">
              <div>
                <label class="text-sm font-medium text-gray-700 mb-1 block">ຮູບພາບສິນຄ້າ</label>
                <div class="flex items-start gap-3">
                  <div
                    class="w-24 h-24 rounded-xl border-2 border-dashed border-gray-200 flex items-center justify-center overflow-hidden bg-gray-50 shrink-0">
                    <img v-if="imagePreview" :src="imagePreview" class="w-full h-full object-cover" />
                    <ImageIcon v-else :size="28" class="text-gray-300" />
                  </div>
                  <div class="flex-1">
                    <label
                      class="inline-flex items-center gap-2 px-4 py-2 bg-gray-100 hover:bg-gray-200 rounded-xl cursor-pointer text-sm">
                      <Upload :size="16" />
                      ເລືອກຮູບ
                      <input type="file" accept="image/*" class="hidden" @change="onFileChange" />
                    </label>
                    <p class="text-xs text-gray-400 mt-2">PNG, JPG, WEBP ຂนาดไม่เกิน 5MB</p>
                    <button v-if="imagePreview" type="button" @click="clearImage"
                      class="text-xs text-red-500 hover:underline mt-1">
                      ລຶບຮູບ
                    </button>
                  </div>
                </div>
              </div>
              <div>
                <input v-model="name" class="input" placeholder="ຊື່ສິນຄ້າ" />
                <span v-if="errors.name" class="text-red-500 text-xs flex items-center gap-1">
                  <AlertCircle :size="10" /> {{ errors.name }}
                </span>
              </div>
              <div>
                <textarea v-model="description" class="input" placeholder="ລາຍລະອຽດ" />
                <span v-if="errors.description" class="text-red-500 text-xs">{{
                  errors.description
                }}</span>
              </div>
              <div class="grid grid-cols-2 gap-3">
                <div>
                  <input v-model.number="price" class="input" type="number" step="0.01" placeholder="ລາຄາ" />
                  <span v-if="errors.price" class="text-red-500 text-xs">{{
                    errors.price
                  }}</span>
                </div>
                <div>
                  <input v-model.number="stock" class="input" type="number" placeholder="ສະຕ໋ອກ" />
                  <span v-if="errors.stock" class="text-red-500 text-xs">{{
                    errors.stock
                  }}</span>
                </div>
              </div>
              <div>
                <select v-model="categoryId" class="input">
                  <option value="">ເລືອກໝວດໝູ່</option>
                  <option v-for="c in categories" :key="c.id" :value="c.id">
                    {{ c.name }}
                  </option>
                </select>
                <span v-if="errors.categoryId" class="text-red-500 text-xs">{{
                  errors.categoryId
                }}</span>
              </div>

              <div class="flex gap-2 pt-2">
                <button type="button" @click="closeModal" class="btn-secondary flex-1">
                  ຍົກເລີກ
                </button>
                <button :disabled="isSubmitting" class="btn-primary flex-1 flex items-center justify-center gap-2">
                  <Save :size="16" />
                  {{ editingId ? "ອັບເດດ" : "ເພີ່ມສິນຄ້າ" }}
                </button>
              </div>
            </form>
          </div>
        </div>
      </Transition>
    </Teleport>
  </div>
</template>

<script setup lang="ts">
import {
  Package,
  Plus,
  Tag,
  DollarSign,
  Calendar,
  Edit,
  Trash2,
  Save,
  AlertCircle,
  ShieldCheck,
  X,
  ChevronLeft,
  ChevronRight,
  Upload,
  Image as ImageIcon,
} from "lucide-vue-next";
import { useForm } from "vee-validate";
import { toast } from "vue3-toastify";
import dayjs from "dayjs";
import { productFormSchema } from "~/composables/useProductSchema";

const auth = useAuthStore();
const { api } = useApi();
onMounted(() => {
  auth.init();
  if (!auth.token) navigateTo("/login");
});

const products = ref<any[]>([]);
const categories = ref<any[]>([]);
const editingId = ref<number | null>(null);
const isModalOpen = ref(false);

const imageFile = ref<File | null>(null);
const imagePreview = ref<string>("");
const existingImage = ref<string>("");

const { baseURL } = useApi();

const fullImageUrl = (url: string) => {
  if (!url) return "https://picsum.photos/200";
  if (url.startsWith("http")) return url;
  return `${baseURL.replace(/\/api$/, "")}${url}`;
};

const onFileChange = (e: Event) => {
  const target = e.target as HTMLInputElement;
  const file = target.files?.[0];
  if (!file) return;
  if (file.size > 5 * 1024 * 1024) {
    toast.error("ຮູບໃຫຍ່ເກີນ 5MB");
    return;
  }
  imageFile.value = file;
  const reader = new FileReader();
  reader.onload = (ev) => {
    imagePreview.value = ev.target?.result as string;
  };
  reader.readAsDataURL(file);
};

const clearImage = () => {
  imageFile.value = null;
  imagePreview.value = "";
  existingImage.value = "";
};

const uploadImage = async (): Promise<string | null> => {
  if (!imageFile.value) return existingImage.value || null;
  const form = new FormData();
  form.append("file", imageFile.value);
  try {
    const res = (await api("/upload", { method: "POST", body: form })) as any;
    return res.url;
  } catch (e) {
    toast.error("ອັບໂຫລດຮູບບໍ່ສຳເລັດ");
    return null;
  }
};

const pageSize = 6;
const currentPage = ref(1);

const totalPages = computed(() =>
  Math.max(1, Math.ceil(products.value.length / pageSize))
);

const paginatedProducts = computed(() => {
  const start = (currentPage.value - 1) * pageSize;
  return products.value.slice(start, start + pageSize);
});

const visiblePages = computed(() => {
  const pages: number[] = [];
  const max = totalPages.value;
  const current = currentPage.value;
  const window = 1;
  for (let i = 1; i <= max; i++) {
    if (
      i === 1 ||
      i === max ||
      (i >= current - window && i <= current + window)
    ) {
      pages.push(i);
    }
  }
  return pages;
});

const goToPage = (page: number) => {
  if (page >= 1 && page <= totalPages.value) currentPage.value = page;
};
const prevPage = () => goToPage(currentPage.value - 1);
const nextPage = () => goToPage(currentPage.value + 1);

const { handleSubmit, errors, defineField, isSubmitting, setValues } = useForm({
  validationSchema: productFormSchema,
});
const [name] = defineField("name");
const [description] = defineField("description");
const [price] = defineField("price");
const [stock] = defineField("stock");
const [categoryId] = defineField("categoryId");

stock.value = 10;

const load = async () => {
  products.value = (await api("/products")) as any;
  categories.value = (await api("/categories")) as any;
};
await load();

const openCreate = () => {
  editingId.value = null;
  setValues({ name: "", description: "", price: 0, stock: 10, categoryId: "" });
  imageFile.value = null;
  imagePreview.value = "";
  existingImage.value = "";
  isModalOpen.value = true;
};

const openEdit = (p: any) => {
  editingId.value = p.id;
  setValues({
    name: p.name,
    description: p.description,
    price: p.price,
    stock: p.stock,
    categoryId: p.categoryId,
  });
  imageFile.value = null;
  existingImage.value = p.images?.[0] || "";
  imagePreview.value = existingImage.value
    ? fullImageUrl(existingImage.value)
    : "";
  isModalOpen.value = true;
};

const closeModal = () => {
  isModalOpen.value = false;
  editingId.value = null;
  imageFile.value = null;
  imagePreview.value = "";
  existingImage.value = "";
};

const onSubmit = handleSubmit(async (values) => {
  const uploadedUrl = await uploadImage();
  const imageUrl =
    uploadedUrl || `https://picsum.photos/seed/${Date.now()}/500/500`;
  const payload = {
    ...values,
    images: [imageUrl],
    isFeatured: false,
  };
  try {
    if (editingId.value) {
      await api(`/products/${editingId.value}`, {
        method: "PUT",
        body: payload,
      });
      toast.success("ອັບເດດສິນຄ້າສຳເລັດ");
    } else {
      await api("/products", { method: "POST", body: payload });
      toast.success("ເພີ່ມສິນຄ້າສຳເລັດ 🎉");
    }
    closeModal();
    setValues({
      name: "",
      description: "",
      price: 0,
      stock: 10,
      categoryId: "",
    });
    currentPage.value = 1;
    await load();
  } catch (e: any) {
    toast.error("ເກີດຂໍ້ຜິດພາດ");
  }
});

const deleteProduct = async (id: number) => {
  if (confirm("ລົບ?")) {
    await api(`/products/${id}`, { method: "DELETE" });
    toast.success("ລົບແລ້ວ");
    if (paginatedProducts.value.length === 1 && currentPage.value > 1) {
      currentPage.value--;
    }
    await load();
  }
};
</script>

<style scoped>
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.2s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}
</style>