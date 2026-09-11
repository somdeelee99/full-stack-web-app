import 'package:get/get.dart';
import 'package:shopadmin/app/data/repositories/dashboard_repository.dart';
import 'package:shopadmin/app/modules/dashboard/controllers/dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardRepository>(() => DashboardRepository());
    Get.lazyPut<DashboardController>(() => DashboardController());
  }
}
