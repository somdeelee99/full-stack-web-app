import 'package:get/get.dart';

/// Route paths for the application
abstract class Routes {
  static const login = '/login';
  static const dashboard = '/dashboard';
  static const products = '/products';
  static const categories = '/categories';
  static const orders = '/orders';
  static const customers = '/customers';
}

/// Page route configuration with bindings
class AppPages {
  static const initial = Routes.login;

  static final routes = [
    GetPage(
      name: Routes.login,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.dashboard,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: Routes.products,
      page: () => const ProductsView(),
      binding: ProductsBinding(),
    ),
    GetPage(
      name: Routes.categories,
      page: () => const CategoriesView(),
      binding: CategoriesBinding(),
    ),
    GetPage(
      name: Routes.orders,
      page: () => const OrdersView(),
      binding: OrdersBinding(),
    ),
    GetPage(
      name: Routes.customers,
      page: () => const CustomersView(),
      binding: CustomersBinding(),
    ),
  ];
}
