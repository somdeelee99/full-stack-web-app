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

    throw Exception('ບໍ່ສາມາດດຶງຂໍ້ມູນລູກຄ້າໄດ້');
  }

  // ດຶງຂໍ້ມູນລູກຄ້າຕາມ ID
  Future<CustomerModel> getCustomerById(int id) async {
    final response = await _apiService.get('/customers/$id');

    if (response.statusCode == 200 && response.data != null) {
      return CustomerModel.fromJson(response.data);
    }

    throw Exception('ບໍ່ພົບຂໍ້ມູນລູກຄ້າ');
  }

  // ສ້າງລູກຄ້າໃໝ່
  Future<CustomerModel> createCustomer(
    Map<String, dynamic> customerData,
  ) async {
    final response = await _apiService.post('/customers', data: customerData);

    if (response.statusCode == 201 && response.data != null) {
      return CustomerModel.fromJson(response.data);
    }

    throw Exception('ບໍ່ສາມາດສ້າງລູກຄ້າໄດ້');
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

    throw Exception('ບໍ່ສາມາດແກ້ໄຂຂໍ້ມູນລູກຄ້າໄດ້');
  }

  // ລຶບລູກຄ້າ
  Future<void> deleteCustomer(int id) async {
    final response = await _apiService.delete('/customers/$id');

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('ບໍ່ສາມາດລຶບລູກຄ້າໄດ້');
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

    throw Exception('ບໍ່ສາມາດດຶງປະຫວັດການຊື້ໄດ້');
  }
}
