import 'package:get/get.dart';
import 'package:shopadmin/app/modules/auth/bindings/auth_binding.dart';
import 'package:shopadmin/app/modules/auth/views/login_view.dart';
import 'package:shopadmin/app/modules/categories/bindings/categories_binding.dart';
import 'package:shopadmin/app/modules/categories/views/categories_view.dart';
import 'package:shopadmin/app/modules/customers/bindings/customers_binding.dart';
import 'package:shopadmin/app/modules/dashboard/bindings/dashboard_binding.dart';
import 'package:shopadmin/app/modules/dashboard/views/dashboard_view.dart';
import 'package:shopadmin/app/modules/orders/bindings/orders_binding.dart';
import 'package:shopadmin/app/modules/orders/views/orders_view.dart';
import 'package:shopadmin/app/modules/products/bindings/products_binding.dart';
import 'package:shopadmin/app/modules/products/views/products_view.dart';

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
