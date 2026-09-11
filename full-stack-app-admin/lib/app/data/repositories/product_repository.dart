import '../api/api_service.dart';
import '../models/product_model.dart';

class ProductRepository {
  final ApiService _apiService;

  ProductRepository(this._apiService);

  // ດຶງລາຍການສິນຄ້າທັງໝົດ
  Future<List<ProductModel>> getProducts({
    int page = 1,
    int limit = 20,
    String? search,
    int? categoryId,
  }) async {
    final response = await _apiService.get(
      '/products',
      queryParameters: {
        'page': page,
        'limit': limit,
        if (search != null) 'search': search,
        if (categoryId != null) 'category_id': categoryId,
      },
    );

    if (response.statusCode == 200 && response.data != null) {
      var data = response.data['data'] ?? response.data;
      if (data is List) {
        return data.map((json) => ProductModel.fromJson(json)).toList();
      }
    }

    throw Exception('ບໍ່ສາມາດດຶງຂໍ້ມູນສິນຄ້າໄດ້');
  }

  // ດຶງຂໍ້ມູນສິນຄ້າຕາມ ID
  Future<ProductModel> getProductById(int id) async {
    final response = await _apiService.get('/products/$id');

    if (response.statusCode == 200 && response.data != null) {
      return ProductModel.fromJson(response.data);
    }

    throw Exception('ບໍ່ພົບຂໍ້ມູນສິນຄ້າ');
  }

  // ສ້າງສິນຄ້າໃໝ່
  Future<ProductModel> createProduct(Map<String, dynamic> productData) async {
    final response = await _apiService.post('/products', data: productData);

    if (response.statusCode == 201 && response.data != null) {
      return ProductModel.fromJson(response.data);
    }

    throw Exception('ບໍ່ສາມາດສ້າງສິນຄ້າໄດ້');
  }

  // ແກ້ໄຂຂໍ້ມູນສິນຄ້າ
  Future<ProductModel> updateProduct(int id, Map<String, dynamic> productData) async {
    final response = await _apiService.put('/products/$id', data: productData);

    if (response.statusCode == 200 && response.data != null) {
      return ProductModel.fromJson(response.data);
    }

    throw Exception('ບໍ່ສາມາດແກ້ໄຂຂໍ້ມູນສິນຄ້າໄດ້');
  }

  // ລຶບສິນຄ້າ
  Future<void> deleteProduct(int id) async {
    final response = await _apiService.delete('/products/$id');

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('ບໍ່ສາມາດລຶບສິນຄ້າໄດ້');
    }
  }

  // Upload ຮູບພາບສິນຄ້າ
  Future<String> uploadProductImage(String imagePath) async {
    // TODO: Implement file upload
    throw UnimplementedError('Upload image not implemented yet');
  }
}
