// import 'package:get/get.dart';

// /// Dashboard Controller
// /// Handles dashboard data and statistics
// class DashboardController extends GetxController {
//   final RxBool isLoading = false.obs;
//   final RxString errorMessage = ''.obs;

//   // Statistics
//   final RxInt totalProducts = 0.obs;
//   final RxInt totalCustomers = 0.obs;
//   final RxInt totalOrders = 0.obs;
//   final RxDouble totalRevenue = 0.0.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     loadDashboardData();
//   }

//   Future<void> loadDashboardData() async {
//     try {
//       isLoading.value = true;
//       errorMessage.value = '';
//       // TODO: Call repository to fetch dashboard data
//       // final data = await Get.find<DashboardRepository>().getDashboardStats();
//       // totalProducts.value = data['products'];
//       // totalCustomers.value = data['customers'];
//       // totalOrders.value = data['orders'];
//       // totalRevenue.value = data['revenue'];
//     } catch (e) {
//       errorMessage.value = 'Failed to load dashboard: $e';
//       Get.snackbar('Error', errorMessage.value);
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }

// import 'package:get/get.dart';

// /// Dashboard Controller
// /// Handles dashboard data and statistics
// class DashboardController extends GetxController {
//   final RxBool isLoading = false.obs;
//   final RxString errorMessage = ''.obs;

//   // Statistics
//   final RxInt totalProducts = 0.obs;
//   final RxInt totalCustomers = 0.obs;
//   final RxInt totalOrders = 0.obs;
//   final RxDouble totalRevenue = 0.0.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     loadDashboardData();
//   }

//   Future<void> loadDashboardData() async {
//     try {
//       isLoading.value = true;
//       errorMessage.value = '';
//       // TODO: Call repository to fetch dashboard data
//       // final data = await Get.find<DashboardRepository>().getDashboardStats();
//       // totalProducts.value = data['products'];
//       // totalCustomers.value = data['customers'];
//       // totalOrders.value = data['orders'];
//       // totalRevenue.value = data['revenue'];
//     } catch (e) {
//       errorMessage.value = 'Failed to load dashboard: $e';
//       Get.snackbar('Error', errorMessage.value);
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }

import 'package:get/get.dart';
import 'package:shopadmin/app/core/errors/error_handler.dart';
import 'package:shopadmin/app/data/models/chart_point_model.dart';

/// Dashboard Controller
/// Handles dashboard data and statistics
class DashboardController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // Statistics
  final RxInt totalProducts = 0.obs;
  final RxInt totalCustomers = 0.obs;
  final RxInt totalOrders = 0.obs;
  final RxDouble totalRevenue = 0.0.obs;

  // Chart Data
  final RxList<ChartPoint> salesChartData = <ChartPoint>[].obs;
  final RxList<ChartPoint> ordersChartData = <ChartPoint>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      // TODO: Call repository to fetch dashboard data
      // final data = await Get.find<DashboardRepository>().getDashboardStats();
      // totalProducts.value = data['products'];
      // totalCustomers.value = data['customers'];
      // totalOrders.value = data['orders'];
      // totalRevenue.value = data['revenue'];
    } catch (e, s) {
      errorMessage.value = ErrorHandler.handle(
        e,
        s,
        context: 'DashboardController.loadDashboardData',
      );
      Get.snackbar('ຜິດພາດ', errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }
}
