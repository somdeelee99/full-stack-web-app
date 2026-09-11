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

    throw Exception('ບໍ່ສາມາດດຶງຂໍ້ມູນຄຳສັ່ງຊື້ໄດ້');
  }

  // ດຶງຂໍ້ມູນຄຳສັ່ງຊື້ຕາມ ID
  Future<OrderModel> getOrderById(int id) async {
    final response = await _apiService.get('/orders/$id');

    if (response.statusCode == 200 && response.data != null) {
      return OrderModel.fromJson(response.data);
    }

    throw Exception('ບໍ່ພົບຂໍ້ມູນຄຳສັ່ງຊື້');
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

    throw Exception('ບໍ່ສາມາດອັບເດດສະຖານະຄຳສັ່ງຊື້ໄດ້');
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

    throw Exception('ບໍ່ສາມາດຍົກເລີກຄຳສັ່ງຊື້ໄດ້');
  }
}
