import '../../core/errors/app_exception.dart';
import 'package:shopadmin/app/data/models/order_model.dart';

import '../api/api_service.dart';
import '../models/customer_model.dart';

class CustomerRepository {
  final ApiService _apiService;

  CustomerRepository(this._apiService);

  // ດຶງລາຍການລູກຄ້າທັງໝົດ
  Future<List<CustomerModel>> getCustomers({
    int page = 1,
    int limit = 20,
    String? search,
  }) async {
    final response = await _apiService.get(
      '/customers',
      queryParameters: {
        'page': page,
        'limit': limit,
        if (search != null) 'search': search,
      },
    );

    if (response.statusCode == 200 && response.data != null) {
      var data = response.data['data'] ?? response.data;
      if (data is List) {
        return data.map((json) => CustomerModel.fromJson(json)).toList();
      }
    }

    throw ParseException.withDetails(
      'ບໍ່ສາມາດດຶງຂໍ້ມູນລູກຄ້າໄດ້',
      originalError: response.data,
      endpoint: 'GET /customers',
      context: {'statusCode': response.statusCode},
    );
  }

  // ດຶງຂໍ້ມູນລູກຄ້າຕາມ ID
  Future<CustomerModel> getCustomerById(int id) async {
    final response = await _apiService.get('/customers/$id');

    if (response.statusCode == 200 && response.data != null) {
      return CustomerModel.fromJson(response.data);
    }

    throw NotFoundException.withDetails(
      'ບໍ່ພົບຂໍ້ມູນລູກຄ້າ',
      originalError: response.data,
      endpoint: 'GET /customers/$id',
    );
  }

  // ສ້າງລູກຄ້າໃໝ່
  Future<CustomerModel> createCustomer(
    Map<String, dynamic> customerData,
  ) async {
    final response = await _apiService.post('/customers', data: customerData);

    if (response.statusCode == 201 && response.data != null) {
      return CustomerModel.fromJson(response.data);
    }

    throw ServerException.withDetails(
      'ບໍ່ສາມາດສ້າງລູກຄ້າໄດ້',
      statusCode: response.statusCode,
      originalError: response.data,
      endpoint: 'POST /customers',
    );
  }

  // ແກ້ໄຂຂໍ້ມູນລູກຄ້າ
  Future<CustomerModel> updateCustomer(
    int id,
    Map<String, dynamic> customerData,
  ) async {
    final response = await _apiService.put(
      '/customers/$id',
      data: customerData,
    );

    if (response.statusCode == 200 && response.data != null) {
      return CustomerModel.fromJson(response.data);
    }

    throw ServerException.withDetails(
      'ບໍ່ສາມາດແກ້ໄຂຂໍ້ມູນລູກຄ້າໄດ້',
      statusCode: response.statusCode,
      originalError: response.data,
      endpoint: 'PUT /customers/$id',
    );
  }

  // ລຶບລູກຄ້າ
  Future<void> deleteCustomer(int id) async {
    final response = await _apiService.delete('/customers/$id');

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw ServerException.withDetails(
        'ບໍ່ສາມາດລຶບລູກຄ້າໄດ້',
        statusCode: response.statusCode,
        originalError: response.data,
        endpoint: 'DELETE /customers/$id',
      );
    }
  }

  // ດຶງປະຫວັດການຊື້ຂອງລູກຄ້າ
  Future<List<OrderModel>> getCustomerOrders(int customerId) async {
    final response = await _apiService.get('/customers/$customerId/orders');

    if (response.statusCode == 200 && response.data != null) {
      var data = response.data['data'] ?? response.data;
      if (data is List) {
        return data.map((json) => OrderModel.fromJson(json)).toList();
      }
    }

    throw ParseException.withDetails(
      'ບໍ່ສາມາດດຶງປະຫວັດການຊື້ໄດ້',
      originalError: response.data,
      endpoint: 'GET /customers/$customerId/orders',
      context: {'statusCode': response.statusCode},
    );
  }
}
