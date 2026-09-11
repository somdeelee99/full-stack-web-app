export const useApi = () => {
  const config = useRuntimeConfig();
  const authStore = useAuthStore();

  const api = $fetch.create({
    baseURL: config.public.apiBase as string,
    onRequest({ options }) {
      const token =
        authStore.token ||
        (typeof window !== "undefined"
          ? localStorage.getItem("admin_token")
          : "");
      if (token) {
        options.headers = {
          ...options.headers,
          Authorization: `Bearer ${token}`,
        };
      }
    },
  });

  return { api, baseURL: config.public.apiBase };
};
