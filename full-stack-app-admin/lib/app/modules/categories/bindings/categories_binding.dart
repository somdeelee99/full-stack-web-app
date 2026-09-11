import 'package:get/get.dart';

import 'package:shopadmin/app/data/repositories/category_repository.dart';
import 'package:shopadmin/app/modules/categories/controllers/categories_controller.dart';

class CategoriesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CategoryRepository>(() => CategoryRepository(Get.find()));
    Get.lazyPut<CategoriesController>(() => CategoriesController());
  }
}
