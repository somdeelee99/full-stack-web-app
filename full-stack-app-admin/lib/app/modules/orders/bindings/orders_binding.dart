import 'package:get/get.dart';
import 'package:shopadmin/app/data/repositories/orders_repository.dart';
import 'package:shopadmin/app/modules/orders/controllers/orders_controller.dart';

class OrdersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrdersRepository>(() => OrdersRepository());
    Get.lazyPut<OrdersController>(() => OrdersController());
  }
}
