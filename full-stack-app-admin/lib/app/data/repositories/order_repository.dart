import '../../core/errors/app_exception.dart';
import '../api/api_service.dart';
import '../models/order_model.dart';

class OrderRepository {
  final ApiService _apiService;

  OrderRepository(this._apiService);

  // ດຶງລາຍການຄຳສັ່ງຊື້ທັງໝົດ
  Future<List<OrderModel>> getOrders({
    int page = 1,
    int limit = 20,
    String? status,
    String? search,
  }) async {
    final response = await _apiService.get(
      '/orders',
      queryParameters: {
        'page': page,
        'limit': limit,
        if (status != null) 'status': status,
        if (search != null) 'search': search,
      },
    );

    if (response.statusCode == 200 && response.data != null) {
      var data = response.data['data'] ?? response.data;
      if (data is List) {
        return data.map((json) => OrderModel.fromJson(json)).toList();
      }
    }

    throw ParseException.withDetails(
      'ບໍ່ສາມາດດຶງຂໍ້ມູນຄຳສັ່ງຊື້ໄດ້',
      originalError: response.data,
      endpoint: 'GET /orders',
      context: {'statusCode': response.statusCode},
    );
  }

  // ດຶງຂໍ້ມູນຄຳສັ່ງຊື້ຕາມ ID
  Future<OrderModel> getOrderById(int id) async {
    final response = await _apiService.get('/orders/$id');

    if (response.statusCode == 200 && response.data != null) {
      return OrderModel.fromJson(response.data);
    }

    throw NotFoundException.withDetails(
      'ບໍ່ພົບຂໍ້ມູນຄຳສັ່ງຊື້',
      originalError: response.data,
      endpoint: 'GET /orders/$id',
    );
  }

  // ອັບເດດສະຖານະຄຳສັ່ງຊື້
  Future<OrderModel> updateOrderStatus(int id, String status) async {
    final response = await _apiService.put(
      '/orders/$id/status',
      data: {'status': status},
    );

    if (response.statusCode == 200 && response.data != null) {
      return OrderModel.fromJson(response.data);
    }

    throw ServerException.withDetails(
      'ບໍ່ສາມາດອັບເດດສະຖານະຄຳສັ່ງຊື້ໄດ້',
      statusCode: response.statusCode,
      originalError: response.data,
      endpoint: 'PUT /orders/$id/status',
    );
  }

  // ຍົກເລີກຄຳສັ່ງຊື້
  Future<OrderModel> cancelOrder(int id, String? reason) async {
    final response = await _apiService.post(
      '/orders/$id/cancel',
      data: {'reason': reason},
    );

    if (response.statusCode == 200 && response.data != null) {
      return OrderModel.fromJson(response.data);
    }

    throw ServerException.withDetails(
      'ບໍ່ສາມາດຍົກເລີກຄຳສັ່ງຊື້ໄດ້',
      statusCode: response.statusCode,
      originalError: response.data,
      endpoint: 'POST /orders/$id/cancel',
    );
  }
}
