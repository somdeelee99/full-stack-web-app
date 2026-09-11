import 'package:get/get.dart';
import '../../data/repositories/product_repository.dart';
import '../../data/models/product_model.dart';

class ProductsController extends GetxController {
  final ProductRepository _repository = ProductRepository();
  
  final RxList<ProductModel> products = <ProductModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  
  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }
  
  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final fetchedProducts = await _repository.getProducts();
      products.value = fetchedProducts;
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Error', 'Failed to load products');
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> deleteProduct(String id) async {
    try {
      await _repository.deleteProduct(id);
      products.removeWhere((product) => product.id == id);
      Get.snackbar('Success', 'Product deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete product');
    }
  }
}
