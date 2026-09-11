import 'package:get/get.dart';
import 'package:shopadmin/app/data/repositories/customers_repository.dart';
import 'package:shopadmin/app/modules/customers/controllers/customers_controller.dart';

class CustomersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CustomersRepository>(() => CustomersRepository());
    Get.lazyPut<CustomersController>(() => CustomersController());
  }
}
