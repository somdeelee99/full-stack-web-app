import { z } from "zod";
import { toTypedSchema } from "@vee-validate/zod";

export const productZodSchema = z.object({
  name: z.string().min(3, "ຊື່ສິນຄ້າຕ້ອງຫຼາຍກວ່າ 3 ໂຕອັກສອນ"),
  description: z.string().min(10, "ລາຍລະອຽດຕ້ອງຫຼາຍກວ່າ 10 ໂຕອັກສອນ"),
  price: z.number().min(1, "ລາຄາຕ້ອງຫຼາຍກວ່າ 0"),
  stock: z.number().min(0, "ສະຕ໋ອກຫ້າມຕິດລົບ"),
  categoryId: z
    .number({ required_error: "ເລືອກໝວດໝູ່ແດ່" })
    .min(1, "ເລືອກໝວດໝູ່"),
});

export const productFormSchema = toTypedSchema(productZodSchema);

export const loginZodSchema = z.object({
  email: z.string().email("ອີເມວບໍ່ຖືກຕ້ອງ"),
  password: z.string().min(6, "ລະຫັດຜ່ານຕ້ອງຫຼາຍກວ່າ 6 ໂຕ"),
});

export const loginFormSchema = toTypedSchema(loginZodSchema);
