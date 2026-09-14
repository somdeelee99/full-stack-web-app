import '../../core/errors/app_exception.dart';
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

    throw ParseException.withDetails(
      'ບໍ່ສາມາດດຶງຂໍ້ມູນສິນຄ້າໄດ້',
      originalError: response.data,
      endpoint: 'GET /products',
      context: {'statusCode': response.statusCode},
    );
  }

  // ດຶງຂໍ້ມູນສິນຄ້າຕາມ ID
  Future<ProductModel> getProductById(int id) async {
    final response = await _apiService.get('/products/$id');

    if (response.statusCode == 200 && response.data != null) {
      return ProductModel.fromJson(response.data);
    }

    throw NotFoundException.withDetails(
      'ບໍ່ພົບຂໍ້ມູນສິນຄ້າ',
      originalError: response.data,
      endpoint: 'GET /products/$id',
    );
  }

  // ສ້າງສິນຄ້າໃໝ່
  Future<ProductModel> createProduct(Map<String, dynamic> productData) async {
    final response = await _apiService.post('/products', data: productData);

    if (response.statusCode == 201 && response.data != null) {
      return ProductModel.fromJson(response.data);
    }

    throw ServerException.withDetails(
      'ບໍ່ສາມາດສ້າງສິນຄ້າໄດ້',
      statusCode: response.statusCode,
      originalError: response.data,
      endpoint: 'POST /products',
    );
  }

  // ແກ້ໄຂຂໍ້ມູນສິນຄ້າ
  Future<ProductModel> updateProduct(
    int id,
    Map<String, dynamic> productData,
  ) async {
    final response = await _apiService.put('/products/$id', data: productData);

    if (response.statusCode == 200 && response.data != null) {
      return ProductModel.fromJson(response.data);
    }

    throw ServerException.withDetails(
      'ບໍ່ສາມາດແກ້ໄຂຂໍ້ມູນສິນຄ້າໄດ້',
      statusCode: response.statusCode,
      originalError: response.data,
      endpoint: 'PUT /products/$id',
    );
  }

  // ລຶບສິນຄ້າ
  Future<void> deleteProduct(int id) async {
    final response = await _apiService.delete('/products/$id');

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw ServerException.withDetails(
        'ບໍ່ສາມາດລຶບສິນຄ້າໄດ້',
        statusCode: response.statusCode,
        originalError: response.data,
        endpoint: 'DELETE /products/$id',
      );
    }
  }

  // Upload ຮູບພາບສິນຄ້າ
  Future<String> uploadProductImage(String imagePath) async {
    // TODO: Implement file upload
    throw UnimplementedError('Upload image not implemented yet');
  }
}
