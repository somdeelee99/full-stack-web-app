import 'package:get/get.dart';
import '../../data/repositories/category_repository.dart';
import '../../data/models/category_model.dart';

class CategoriesController extends GetxController {
  final CategoryRepository _repository = CategoryRepository();
  
  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  
  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }
  
  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final fetchedCategories = await _repository.getCategories();
      categories.value = fetchedCategories;
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Error', 'Failed to load categories');
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> deleteCategory(String id) async {
    try {
      await _repository.deleteCategory(id);
      categories.removeWhere((category) => category.id == id);
      Get.snackbar('Success', 'Category deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete category');
    }
  }
}
