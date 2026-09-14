import '../../core/errors/app_exception.dart';
import '../api/api_service.dart';
import '../models/category_model.dart';

class CategoryRepository {
  final ApiService _apiService;

  CategoryRepository(this._apiService);

  // ດຶງລາຍການໝວດໝູ່ທັງໝົດ
  Future<List<CategoryModel>> getCategories() async {
    final response = await _apiService.get('/categories');

    if (response.statusCode == 200 && response.data != null) {
      var data = response.data['data'] ?? response.data;
      if (data is List) {
        return data.map((json) => CategoryModel.fromJson(json)).toList();
      }
    }

    throw ParseException.withDetails(
      'ບໍ່ສາມາດດຶງຂໍ້ມູນໝວດໝູ່ໄດ້',
      originalError: response.data,
      endpoint: 'GET /categories',
      context: {'statusCode': response.statusCode},
    );
  }

  // ດຶງຂໍ້ມູນໝວດໝູ່ຕາມ ID
  Future<CategoryModel> getCategoryById(int id) async {
    final response = await _apiService.get('/categories/$id');

    if (response.statusCode == 200 && response.data != null) {
      return CategoryModel.fromJson(response.data);
    }

    throw NotFoundException.withDetails(
      'ບໍ່ພົບຂໍ້ມູນໝວດໝູ່',
      originalError: response.data,
      endpoint: 'GET /categories/$id',
    );
  }

  // ສ້າງໝວດໝູ່ໃໝ່
  Future<CategoryModel> createCategory(
    Map<String, dynamic> categoryData,
  ) async {
    final response = await _apiService.post('/categories', data: categoryData);

    if (response.statusCode == 201 && response.data != null) {
      return CategoryModel.fromJson(response.data);
    }

    throw ServerException.withDetails(
      'ບໍ່ສາມາດສ້າງໝວດໝູ່ໄດ້',
      statusCode: response.statusCode,
      originalError: response.data,
      endpoint: 'POST /categories',
    );
  }

  // ແກ້ໄຂຂໍ້ມູນໝວດໝູ່
  Future<CategoryModel> updateCategory(
    int id,
    Map<String, dynamic> categoryData,
  ) async {
    final response = await _apiService.put(
      '/categories/$id',
      data: categoryData,
    );

    if (response.statusCode == 200 && response.data != null) {
      return CategoryModel.fromJson(response.data);
    }

    throw ServerException.withDetails(
      'ບໍ່ສາມາດແກ້ໄຂຂໍ້ມູນໝວດໝູ່ໄດ້',
      statusCode: response.statusCode,
      originalError: response.data,
      endpoint: 'PUT /categories/$id',
    );
  }

  // ລຶບໝວດໝູ່
  Future<void> deleteCategory(int id) async {
    final response = await _apiService.delete('/categories/$id');

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw ServerException.withDetails(
        'ບໍ່ສາມາດລຶບໝວດໝູ່ໄດ້',
        statusCode: response.statusCode,
        originalError: response.data,
        endpoint: 'DELETE /categories/$id',
      );
    }
  }
}
