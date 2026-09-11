import 'package:get/get.dart';
import 'package:shopadmin/app/data/repositories/product_repository.dart';
import 'package:shopadmin/app/modules/products/controllers/products_controller.dart';

class ProductsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductRepository>(() => ProductRepository(Get.find()));
    Get.lazyPut<ProductsController>(() => ProductsController());
  }
}
