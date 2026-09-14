import 'package:get/get.dart';
import 'package:shopadmin/app/core/errors/error_handler.dart';
import 'package:shopadmin/app/data/models/category_model.dart';
import 'package:shopadmin/app/data/repositories/category_repository.dart';

class CategoriesController extends GetxController {
  final CategoryRepository _repository = CategoryRepository(Get.find());

  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final fetchedCategories = await _repository.getCategories();
      categories.value = fetchedCategories;
    } catch (e, s) {
      errorMessage.value = ErrorHandler.handle(
        e,
        s,
        context: 'CategoriesController.fetchCategories',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteCategory(int id) async {
    try {
      await _repository.deleteCategory(id);
      categories.removeWhere((category) => category.id == id);
      Get.snackbar('Success', 'Category deleted successfully');
    } catch (e, s) {
      ErrorHandler.handleWithSnackbar(
        e,
        s,
        context: 'CategoriesController.deleteCategory',
        details: {'categoryId': id},
      );
    }
  }
}
