import 'package:get/get.dart';
import 'package:shopadmin/app/data/repositories/customer_repository.dart';
import 'package:shopadmin/app/modules/customers/controllers/customers_controller.dart';

class CustomersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CustomerRepository>(() => CustomerRepository(Get.find()));
    Get.lazyPut<CustomersController>(() => CustomersController());
  }
}
