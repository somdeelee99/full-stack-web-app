import '../api/api_service.dart';
import '../models/dashboard_model.dart';

class DashboardRepository {
  final ApiService _apiService;

  DashboardRepository(this._apiService);

  // ດຶງຂໍ້ມູນສະຖິຕິ Dashboard
  Future<DashboardStatsModel> getDashboardStats() async {
    final response = await _apiService.get('/dashboard/stats');

    if (response.statusCode == 200 && response.data != null) {
      return DashboardStatsModel.fromJson(response.data);
    }

    throw Exception('ບໍ່ສາມາດດຶງຂໍ້ມູນ Dashboard ໄດ້');
  }

  // ດຶງຂໍ້ມູນ Revenue Chart (ລາຍຮັບແຕ່ລະວັນ/ເດືອນ)
  Future<List<Map<String, dynamic>>> getRevenueChart({
    String period = 'month', // day, week, month, year
  }) async {
    final response = await _apiService.get(
      '/dashboard/revenue-chart',
      queryParameters: {'period': period},
    );

    if (response.statusCode == 200 && response.data != null) {
      return List<Map<String, dynamic>>.from(response.data);
    }

    throw Exception('ບໍ່ສາມາດດຶງຂໍ້ມູນ Revenue Chart ໄດ້');
  }

  // ດຶງຂໍ້ມູນ Orders Chart
  Future<List<Map<String, dynamic>>> getOrdersChart({
    String period = 'month',
  }) async {
    final response = await _apiService.get(
      '/dashboard/orders-chart',
      queryParameters: {'period': period},
    );

    if (response.statusCode == 200 && response.data != null) {
      return List<Map<String, dynamic>>.from(response.data);
    }

    throw Exception('ບໍ່ສາມາດດຶງຂໍ້ມູນ Orders Chart ໄດ້');
  }
}
