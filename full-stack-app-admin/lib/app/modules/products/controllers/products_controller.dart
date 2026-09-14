import 'package:get/get.dart';
import 'package:shopadmin/app/core/errors/error_handler.dart';
import 'package:shopadmin/app/data/models/product_model.dart';
import 'package:shopadmin/app/data/repositories/product_repository.dart';

class ProductsController extends GetxController {
  final ProductRepository _repository = ProductRepository(Get.find());

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
    } catch (e, s) {
      errorMessage.value = ErrorHandler.handle(
        e,
        s,
        context: 'ProductsController.fetchProducts',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      await _repository.deleteProduct(id);
      products.removeWhere((product) => product.id == id);
      Get.snackbar('Success', 'Product deleted successfully');
    } catch (e, s) {
      ErrorHandler.handleWithSnackbar(
        e,
        s,
        context: 'ProductsController.deleteProduct',
        details: {'productId': id},
      );
    }
  }
}
